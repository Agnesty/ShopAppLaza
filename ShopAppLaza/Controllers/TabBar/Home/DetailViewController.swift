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
    var product: WelcomeElement?
    var detailProductData: DetailProduct?
    var detailProductSize = [Size]()
    var detailProductReviews = [Review]()
    var updateWishlist: UpdateWishlist?
    let imgFavorite = UserDefaults.standard.string(forKey: "imageFavorite")
    
    
    //MARK: IBOutlet
    @IBOutlet weak var viewAllReviews: UIButton!
    @IBOutlet weak var sizeCollection: UICollectionView!
    @IBOutlet weak var favorite: UIButton!{
        didSet{
            guard let imgFav = imgFavorite else { return }
            favorite.layer.cornerRadius = 22
            favorite.setImage(UIImage(systemName: imgFav), for: .normal)
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
                
                // Determine the image name based on the message received
                var imageName: String
                if let message = self?.updateWishlist?.data {
                    if message == "successfully delete wishlist" {
                        imageName = "heart"
                    } else if message == "successfully added wishlist" {
                        imageName = "heart.fill"
                    } else {
                        imageName = "heart" // Default image
                    }
                } else {
                    imageName = "heart" // Default image
                }
                
                // Update the button image
                let image = UIImage(systemName: imageName)
                self?.favorite.setImage(image, for: .normal)
                UserDefaults.standard.set(imageName, forKey: "imageFavorite")
                
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
//    func getImageFromFavorites(productId: Int) -> UIImage? {
//        if let imageData = UserDefaults.standard.data(forKey: "\(productId)_imageFavorite") {
//            return UIImage(data: imageData)
//        }
//        return nil
//    }
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
