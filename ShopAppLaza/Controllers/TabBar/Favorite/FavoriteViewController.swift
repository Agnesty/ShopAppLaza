//
//  FavoriteViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 26/07/23.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    private var favoriteVM = FavoriteViewModel()
    private var detailData: DetailViewController?
    var wishlist: Wishlist?
    
    //MARK: IBOutlet
    @IBOutlet weak var collectionWishlist: UICollectionView!
    @IBOutlet weak var countWishlist: UILabel!
    @IBOutlet weak var emptyDataLabel: UILabel!
    
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
        favoriteVM.favoriteViewCtr = self
        self.favoriteVM.getFavoriteList(accessTokenKey: APIService().token!) { [weak self] wishlist in
            DispatchQueue.main.async {
                self?.wishlist = wishlist
                self?.countWishlist.text = "\(wishlist.data.total) items"
                self?.collectionWishlist.reloadData()
            }
        }
        
        setupTabBarItemImage()
        collectionWishlist.dataSource = self
        collectionWishlist.delegate = self
        collectionWishlist.register(NewArraivalCollectionViewCell.nib(), forCellWithReuseIdentifier: NewArraivalCollectionViewCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.favoriteVM.getFavoriteList(accessTokenKey: APIService().token!) { [weak self] wishlist in
            DispatchQueue.main.async {
                self?.wishlist = wishlist
                self?.countWishlist.text = "\(wishlist.data.total) items"
                self?.collectionWishlist.reloadData()
            }
        }
    }
    
    //MARK: IBAction
    
    
}

extension FavoriteViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let countProduct = wishlist?.data.products
        if countProduct?.count == 0 {
        self.emptyDataLabel.isHidden = false
        } else {
        self.emptyDataLabel.isHidden = true
        }
        return countProduct?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewArraivalCollectionViewCell.identifier, for: indexPath) as? NewArraivalCollectionViewCell else { return UICollectionViewCell() }
        if let cellWishlist = wishlist?.data.products?[indexPath.row] {
            cell.imageProduct.setImageWithPlugin(url: cellWishlist.imageURL)
            cell.titleProduk.text = cellWishlist.name
            cell.priceProduk.text = String(cellWishlist.price)
        }
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let newArrivalDetailView = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
//        if let product = wishlist?.data.products?[indexPath.item] {
//            let welcomeElement = WelcomeElement(
//                id: product.id,
//                name: product.name,
//                image_url: product.imageURL,
//                price: Double(product.price),
//                created_at: product.createdAt)
//            newArrivalDetailView.product = welcomeElement
//        }
        newArrivalDetailView.productId = wishlist?.data.products?[indexPath.item].id
        self.navigationController?.pushViewController(newArrivalDetailView, animated: true)
        
        
        
        
        
    }
    
}


