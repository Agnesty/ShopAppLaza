//
//  PaymentViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 07/08/23.
//

import UIKit

protocol PassingDataCardDelegate: AnyObject {
    func PassingDataCard(cardNumber: String, bank: String)
}

class PaymentViewController: UIViewController {
    var creditCards: [CardModel] = []
    var coredataManager = CoreDataManager()
    var selectedIndexPath: IndexPath?
    var idCardChoose: String?
    weak var delegate: PassingDataCardDelegate?
    
    //MARK: IBOutlet
    @IBOutlet weak var paymentCollectionView: UICollectionView!
    @IBOutlet weak var nameCard: UITextField!{
        didSet{
            nameCard.isEnabled = false
        }
    }
    @IBOutlet weak var cardNumber: UITextField!{
        didSet{
            cardNumber.isEnabled = false
        }
    }
    @IBOutlet weak var expCard: UITextField!{
        didSet{
            expCard.isEnabled = false
        }
    }
    @IBOutlet weak var cvvCard: UITextField!{
        didSet{
            cvvCard.isEnabled = false
        }
    }
    @IBOutlet weak var addBtn: UIButton!{
        didSet{
            addBtn.layer.cornerRadius = CGFloat(addBtn.frame.width/2)
        }
    }
    @IBOutlet weak var editBtn: UIButton!{
        didSet{
            editBtn.layer.cornerRadius = CGFloat(10)
            if let borderColor = UIColor(hex: "#9775FA")?.cgColor {
                editBtn.layer.borderColor = borderColor
                editBtn.layer.borderWidth = 1.0
            } else {
                print("Gagal mengonversi warna dari format hex.")
            }
        }
    }
    @IBOutlet weak var deleteBtn: UIButton!{
        didSet{
            deleteBtn.layer.cornerRadius = CGFloat(10)
            deleteBtn.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
            let borderColor = UIColor.systemRed.cgColor
            deleteBtn.layer.borderColor = borderColor
            deleteBtn.layer.borderWidth = 1.0
            
        }
    }
    @IBOutlet weak var emptyLabelPage: UILabel!{
        didSet{
            emptyLabelPage.isHidden = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        paymentCollectionView.dataSource = self
        paymentCollectionView.delegate = self
        paymentCollectionView.register(CardPaymentCollectionViewCell.nib(), forCellWithReuseIdentifier: CardPaymentCollectionViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveCard()
    }
    
    //MARK: IBAction
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addCartNumber(_ sender: UIButton) {
        guard let performAddCardNumber = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "AddCardNumberViewController") as? AddCardNumberViewController else { return }
        self.navigationController?.pushViewController(performAddCardNumber, animated: true)
    }
    @IBAction func editCard(_ sender: UIButton) {
        if creditCards.count == 0 {
            showAlert(title: "Can't Edit Card", message: "You don't have any card.")
        } else {
            guard let performAddCardNumber = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "AddCardNumberViewController") as? AddCardNumberViewController else { return }
            performAddCardNumber.creditCardNumber = self.idCardChoose
            performAddCardNumber.edit = true
            self.navigationController?.pushViewController(performAddCardNumber, animated: true)
        }
    }
    @IBAction func deleteCard(_ sender: UIButton) {
        if creditCards.count == 0 {
            showAlert(title: "Can't Delete Card", message: "You don't have any card.")
        } else {
            guard let selectedInd = selectedIndexPath else { return }
            showAlert2(title: "Delete Card", message: "Are you sure you want to delete this card?") {
                self.deleteCardIndex(indexPath: selectedInd)
            }
        }
    }
    @IBAction func saveCard(_ sender: UIButton) {
        guard let numberCard = idCardChoose else { print("ini kosong")
            return
        }
        self.delegate?.PassingDataCard(cardNumber: numberCard, bank: "bni")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: FUNCTION
    func retrieveCard() {
        creditCards.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.coredataManager.retrieveAllCard { creditCard in
                self?.creditCards.append(contentsOf: creditCard)
                if self?.creditCards.count ?? 0 > 0{
                    let indexPath = IndexPath(item: 0, section: 0)
                    self?.performCardInTextfield(indexPath: indexPath)
                    self?.paymentCollectionView.reloadData()
                }
            }
        }
    }
    func deleteCardIndex(indexPath: IndexPath) {
        let card = creditCards[indexPath.row]
            coredataManager.delete(card) { [weak self] in
                DispatchQueue.main.async {
                    self?.creditCards.remove(at: indexPath.row)
                    self?.paymentCollectionView.deleteItems(at: [indexPath])
                    print("successfully delete card")
                }
            }
    }
    func performCardInTextfield(indexPath: IndexPath){
        selectedIndexPath = indexPath
        let card = creditCards[indexPath.item]
        self.idCardChoose = card.numberCard
        nameCard.text = card.ownerCard
        cardNumber.text = card.numberCard
        expCard.text = card.expMonthCard + "/" + card.expYearCard
        cvvCard.text = card.cvvCard
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Menggunakan if let untuk memeriksa apakah selectedCellIndex tidak nil
        guard let selectedIndexPath = selectedIndexPath else { return }
        let currentIndex = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        
        // Dapatkan bagian (section) dari selectedIndexPath
        let selectedSection = selectedIndexPath.section
        // Buat IndexPath baru dengan selectedSection dan currentIndex
        let newIndexPath = IndexPath(item: currentIndex, section: selectedSection)
        
        // Memanggil fungsi performCardInTextfield dengan newIndexPath
        performCardInTextfield(indexPath: newIndexPath)
        
        // Dapat memeriksa apakah currentIndex sama dengan selectedRow atau tidak
        if currentIndex != selectedIndexPath.row {
            // Melakukan tindakan yang sesuai jika currentIndex berbeda
            print("Indeks terpilih setelah berhenti: \(currentIndex)")
        }
    }
    
}

extension PaymentViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cardsCount = creditCards.count
        if cardsCount == 0 {
            self.emptyLabelPage.isHidden = false
        } else {
            self.emptyLabelPage.isHidden = true
        }
        return creditCards.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardPaymentCollectionViewCell.identifier, for: indexPath) as? CardPaymentCollectionViewCell else { return UICollectionViewCell() }
        
        let card = creditCards[indexPath.item]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            cell.configureData(card: card)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performCardInTextfield(indexPath: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width
        print("Screen width: \(width)")
        let heightToWidthRatio: Double = Double(200) / Double(300)
        let height = width * heightToWidthRatio
        print(width, height, separator: " - ")
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
