//
//  PaymentViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 07/08/23.
//

import UIKit

class PaymentViewController: UIViewController {
    
    var creditCards: [CardModel] = []
    var coredataManager = CoreDataManager()
    var selectedIndexPath: IndexPath?
    var idCardChoose: String?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentCollectionView.dataSource = self
        paymentCollectionView.delegate = self
        paymentCollectionView.register(CardPaymentCollectionViewCell.nib(), forCellWithReuseIdentifier: CardPaymentCollectionViewCell.identifier)
        retrieveCard()
//        coredataManager.retrieve { [weak self] creditCard in
//            self?.creditCards.append(contentsOf: creditCard)
//            self?.paymentCollectionView.reloadData()
//        }
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
        guard let performAddCardNumber = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "AddCardNumberViewController") as? AddCardNumberViewController else { return }
        performAddCardNumber.creditCardNumber = self.idCardChoose
        performAddCardNumber.edit = true
        self.navigationController?.pushViewController(performAddCardNumber, animated: true)
        
    }
    
    //MARK: FUNCTION
    func retrieveCard() {
        coredataManager.retrieve { [weak self] creditCard in
            self?.creditCards.append(contentsOf: creditCard)
            self?.paymentCollectionView.reloadData()
        }
    }
    
}

extension PaymentViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return creditCards.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardPaymentCollectionViewCell.identifier, for: indexPath) as? CardPaymentCollectionViewCell else { return UICollectionViewCell() }
        
        let card = creditCards[indexPath.item]
        cell.configureData(card: card)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let card = creditCards[indexPath.item]
        self.idCardChoose = card.numberCard
        nameCard.text = card.ownerCard
        cardNumber.text = card.numberCard
        expCard.text = card.expMonthCard + "/" + card.expYearCard
        cvvCard.text = card.cvvCard
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 300, height: 200)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}
