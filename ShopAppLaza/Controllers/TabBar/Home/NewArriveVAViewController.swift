//
//  NewArriveVAViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 21/08/23.
//

import UIKit

class NewArriveVAViewController: UIViewController {
    
    private var newArrivalTableVM = NewArrivalTableViewModel()
    var productAPI = [WelcomeElement]()
    var isAscendingOrder = true

    //MARK: IBOutlet
    @IBOutlet weak var sortBtn: UIButton!{
        didSet{
            sortBtn.setImage(UIImage(systemName: ""), for: .normal)
            sortBtn.setTitle(" Sort", for: .normal)
        }
    }
    @IBOutlet weak var countItems: UILabel!
    @IBOutlet weak var newArrivalCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        sortData()
        
        newArrivalCollection.dataSource = self
        newArrivalCollection.delegate = self
        newArrivalCollection.register(NewArraivalCollectionViewCell.nib(), forCellWithReuseIdentifier: NewArraivalCollectionViewCell.identifier)
        DispatchQueue.main.async {
            self.newArrivalTableVM.getDataProduct(isMockApi: false) { [weak self] produk in
                guard let produkResponse = produk else { return }
                self?.productAPI.append(contentsOf: produkResponse.data)
                self?.countItems.text = String((self?.productAPI.count)!) + " items"
                self?.newArrivalCollection.reloadData()
            }
        }
    }
    
    //MARK: IBAction
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func sortAction(_ sender: UIButton) {
        toggleSortOrder()
    }
    
    //MARK: FUNCTION
    func toggleSortOrder() {
        isAscendingOrder.toggle()
        sortData()
    }
    func sortData() {
        if sortBtn.currentImage == UIImage(systemName: ""){
            sortBtn.setTitle(" Sort", for: .normal)
            sortBtn.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        } else if isAscendingOrder {
            productAPI.sort { $0.name < $1.name }
            sortBtn.setImage(UIImage(systemName: "text.line.first.and.arrowtriangle.forward"), for: .normal)
            sortBtn.setTitle(" A-Z", for: .normal)
        } else if !isAscendingOrder {
            productAPI.sort { $0.name > $1.name }
            sortBtn.setImage(UIImage(systemName: "text.line.last.and.arrowtriangle.forward"), for: .normal)
            sortBtn.setTitle(" Z-A", for: .normal)
        }
        newArrivalCollection.reloadData()
    }
    
    
}

extension NewArriveVAViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productAPI.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cellNewArraival = collectionView.dequeueReusableCell(withReuseIdentifier: NewArraivalCollectionViewCell.identifier, for: indexPath) as? NewArraivalCollectionViewCell else { return UICollectionViewCell() }
            let newArraival = productAPI[indexPath.row]
            cellNewArraival.imageProduct.setImageWithPlugin(url: newArraival.image_url)
            cellNewArraival.titleProduk.text = newArraival.name
            cellNewArraival.priceProduk.text = "Rp \(String(newArraival.price))"
            return cellNewArraival
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: 160, height: 295)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newArraival = productAPI[indexPath.row]
        guard let newArrivalDetailView = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        self.navigationController?.pushViewController(newArrivalDetailView, animated: true)
        newArrivalDetailView.productId = newArraival.id
        newArrivalDetailView.product = newArraival
    }
}
