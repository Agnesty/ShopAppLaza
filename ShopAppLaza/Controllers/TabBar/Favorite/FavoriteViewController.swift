//
//  FavoriteViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 26/07/23.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var collectionWishlist: UICollectionView!
    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Wishlist"
        label.font = UIFont(name: "Inter", size: 11)
        label.sizeToFit()

        tabBarItem.standardAppearance?.selectionIndicatorTintColor = UIColor(named: "PurpleButton")
        tabBarItem.selectedImage = UIImage(view: label)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItemImage()
        collectionWishlist.dataSource = self
        collectionWishlist.delegate = self
        collectionWishlist.register(NewArraivalCollectionViewCell.nib(), forCellWithReuseIdentifier: NewArraivalCollectionViewCell.identifier)
        collectionWishlist.reloadData()
    }
    
    //MARK: IBAction
    

}

extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewArraivalCollectionViewCell.identifier, for: indexPath) as? NewArraivalCollectionViewCell else { return UICollectionViewCell() }
        cell.imageProduct.image = UIImage(named: "orang2")
        cell.titleProduk.text = "Produk"
        cell.priceProduk.text = "Rp 5.000"
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
