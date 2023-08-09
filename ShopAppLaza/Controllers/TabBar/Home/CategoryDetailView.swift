//
//  CardPaymentViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 08/08/23.
//

import UIKit

class CategoryDetailView: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var logoImage: UIImageView!{
        didSet{
            logoImage.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var categoryBrandCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryBrandCollection.dataSource = self
        categoryBrandCollection.delegate = self
        categoryBrandCollection.register(NewArraivalCollectionViewCell.nib(), forCellWithReuseIdentifier: NewArraivalCollectionViewCell.identifier)
        categoryBrandCollection.reloadData()
    }
    
    //MARK: IBAction
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension CategoryDetailView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewArraivalCollectionViewCell.identifier, for: indexPath) as? NewArraivalCollectionViewCell else { return UICollectionViewCell() }
        cell.imageProduct.image = UIImage(named: "orang1")
        cell.titleProduk.text = "CategoryProductTitle"
        cell.priceProduk.text = "Rp 20.000"
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
