//
//  CardPaymentViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 08/08/23.
//

import UIKit

class CategoryDetailView: UIViewController {
    private let categoryDetailVM = CategoryDetailViewModel()
    var name: String = ""
    var img: String = ""
    var categoryDetail = [Datum]()
    
    //MARK: IBOutlet
    @IBOutlet weak var countItems: UILabel!
    @IBOutlet weak var logoImage: UIImageView!{
        didSet{
            logoImage.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var categoryBrandCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryDetailVM.categoryDetailVC = self
        categoryDetailVM.getDetailBrandById(name: name) { [weak self] produkBrand in
            DispatchQueue.main.async {
                self?.categoryDetail = produkBrand.data
                print("ini adalah produk brand", produkBrand)
                self?.countItems.text = String((self?.categoryDetail.count)!) + " items"
                self?.logoImage.setImageWithPlugin(url: self!.img)
                self?.categoryBrandCollection.reloadData()
            }
            
        }
        categoryBrandCollection.dataSource = self
        categoryBrandCollection.delegate = self
        categoryBrandCollection.register(NewArraivalCollectionViewCell.nib(), forCellWithReuseIdentifier: NewArraivalCollectionViewCell.identifier)
    }
    
    //MARK: IBAction
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CategoryDetailView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryDetail.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewArraivalCollectionViewCell.identifier, for: indexPath) as? NewArraivalCollectionViewCell else { return UICollectionViewCell() }
        let categoryBrand = categoryDetail[indexPath.row]
        cell.imageProduct.setImageWithPlugin(url: categoryBrand.imageURL)
        cell.titleProduk.text = categoryBrand.name.capitalized
        cell.priceProduk.text = "$\(String(categoryBrand.price))"
        
        return cell
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
    
    
}
