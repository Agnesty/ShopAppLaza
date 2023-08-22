//
//  DetailViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 31/07/23.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    private var detailVM = DetailViewModel()
    private var favoriteVM = FavoriteViewModel()
    var product: WelcomeElement?
    var detailProductData: DetailProduct?
    var detailProductSize = [Size]()
    var detailProductReviews = [Review]()
    var updateWishlist: UpdateWishlist?
    var wishlist: DataWishlist?
    let imgFavorite = UserDefaults.standard.string(forKey: "imageFavorite")
    var imageName: String = ""
    
    //MARK: IBOutlet
    @IBOutlet weak var viewAllReviews: UIButton!
    @IBOutlet weak var sizeCollection: UICollectionView!
    @IBOutlet weak var favorite: UIButton!{
        didSet{
            //            guard let imgFav = imgFavorite else { return }
            favorite.layer.cornerRadius = 22
            //            favorite.setImage(UIImage(systemName: imgFav), for: .normal)
        }
    }
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var categoryBrand: UILabel!
    @IBOutlet weak var titleBarang: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var commentReview: UILabel!
    @IBOutlet weak var commentName: UILabel!
    @IBOutlet weak var commentTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Determine the image name based on the message received
        
        sizeCollection.dataSource = self
        sizeCollection.delegate = self
        sizeCollection.register(SizeDetailCollectionViewCell.nib(), forCellWithReuseIdentifier: SizeDetailCollectionViewCell.identifier)
        
        detailVM.getDetailProductById(id: product!.id) {  detailById in
            DispatchQueue.main.async { [weak self] in
                self?.detailProductData = detailById
                self?.detailProductSize.append(contentsOf: detailById.data.size)
                self?.detailProductReviews.append(contentsOf: detailById.data.reviews)
                self?.setProduct()
                
                self?.sizeCollection.reloadData()
            }
        }
        isProductInWishlists { isInWishlist in
            if isInWishlist == true {
                self.imageName = "heart.fill"
            } else {
                self.imageName = "heart"
            }
            // Update the button image
            let image = UIImage(systemName: self.imageName)
            self.favorite.setImage(image, for: .normal)
        }
    }
    
    func isProductInWishlists(completion: @escaping (Bool) -> Void) {
        self.favoriteVM.getFavoriteList(accessTokenKey: APIService().token!) { [weak self] wishlist in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.wishlist = wishlist.data
                guard let productId = self.product?.id else { return }
                let products = wishlist.data.products
                if products.contains(where: { productWishlist in
                    productWishlist.id == productId
                }){
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func setProduct() {
        imageProduct.setImageWithPlugin(url: (detailProductData?.data.imageURL)!)
        categoryBrand.text = detailProductData?.data.category.category.capitalized
        titleBarang.text = detailProductData?.data.name
        priceLabel.text = "$\(detailProductData?.data.price ?? 0)"
        descriptionLabel.text = detailProductData?.data.description
        if let reviews = detailProductReviews.first {
            ratingLabel.text = String(reviews.rating)
            ratingStarData(rating: Double(reviews.rating))
            commentTime.text = DateTimeUtils.shared.formatReview(date: reviews.createdAt)
            commentName.text = reviews.fullName
            commentReview.text = reviews.comment
        }
    }
    
    
    //MARK: IBAction
    @IBAction func favoriteAction(_ sender: UIButton) {
        detailVM.putFavorite(accessTokenKey: APIService().token!, productId: product!.id) { [weak self] updateWishlist in
            DispatchQueue.main.async {
                self?.updateWishlist = updateWishlist
                if let message = self?.updateWishlist?.data {
                    if message == "successfully delete wishlist" {
                        self?.imageName = "heart"
                    } else if message == "successfully added wishlist" {
                        self?.imageName = "heart.fill"
                    } else {
                        self?.imageName = "heart"
                    }
                } else {
                    self?.imageName = "heart"
                }
                // Update the button image
                let image = UIImage(systemName: self?.imageName ?? "heart")
                self?.favorite.setImage(image, for: .normal)
                // Show an alert if needed
                if let message = self?.updateWishlist?.data {
                    self?.showAlert(title: "Wishlist Update", message: message)
                }
            }
        }
        
    }
    
    @IBAction func viewAllReviewAction(_ sender: UIButton) {
        guard let performReviews = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "ReviewsViewController") as? ReviewsViewController else { return }
        performReviews.idProduct = product?.id
        self.navigationController?.pushViewController(performReviews, animated: true)
    }
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func ratingStarData(rating: Double) {
        var collectStar = [Star]()
        var colors = [UIColor]()
        var isHalfStarAdded = false
        for index in 1...5 {
            if isHalfStarAdded {
                collectStar.append(Star.emptyStar)
                colors.append(.systemYellow)
                continue
            }
            let idx = Double(index)
            if idx <= rating {
                collectStar.append(Star.fullStar)
                colors.append(.systemYellow)
            } else if idx - rating > 0, idx - rating < 1 {
                collectStar.append(Star.halfStar)
                colors.append(.systemYellow)
                isHalfStarAdded = true
            } else {
                collectStar.append(Star.emptyStar)
                colors.append(.systemYellow)
            }
        }
        star1.image = UIImage(systemName: collectStar[0].rawValue)
        star2.image = UIImage(systemName: collectStar[1].rawValue)
        star3.image = UIImage(systemName: collectStar[2].rawValue)
        star4.image = UIImage(systemName: collectStar[3].rawValue)
        star5.image = UIImage(systemName: collectStar[4].rawValue)
        star1.tintColor = colors[0]
        star2.tintColor = colors[1]
        star3.tintColor = colors[2]
        star4.tintColor = colors[3]
        star5.tintColor = colors[4]
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailProductSize.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SizeDetailCollectionViewCell.identifier, for: indexPath) as? SizeDetailCollectionViewCell else {
            return UICollectionViewCell() }
        cell.labelSize.text = detailProductSize[indexPath.row].size.uppercased()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
}
