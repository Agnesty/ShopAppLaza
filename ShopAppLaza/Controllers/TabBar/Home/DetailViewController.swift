//
//  DetailViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 31/07/23.
//

import UIKit
import SDWebImage

protocol DetailViewControllerDelegate: AnyObject {
    func didSelectSize(_ sizeId: Int)
}

class DetailViewController: UIViewController {
    private var detailVM = DetailViewModel()
    private var favoriteVM = FavoriteViewModel()
    weak var delegate: DetailViewControllerDelegate?
    var productId: Int?
    var product: WelcomeElement?
    var detailProductData: DetailProduct?
    var detailProductSize = [Size]()
    var detailProductReviews = [Review]()
    var updateWishlist: UpdateWishlist?
    var wishlist: DataWishlist?
    var idSizeChoose: Int?
    var imageName: String = ""
    var selectedIndexPath: IndexPath?
    
    //MARK: IBOutlet
    @IBOutlet weak var viewAllReviews: UIButton!
    @IBOutlet weak var sizeCollection: UICollectionView!
    @IBOutlet weak var favorite: UIButton!{
        didSet{
            favorite.layer.cornerRadius = 22
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
        guard let id = productId else { return }
        self.tabBarController?.tabBar.isHidden = true //Menghilangkan tabbar
        sizeCollection.dataSource = self
        sizeCollection.delegate = self
        sizeCollection.register(SizeDetailCollectionViewCell.nib(), forCellWithReuseIdentifier: SizeDetailCollectionViewCell.identifier)
        
        detailVM.getDetailProductById(id: id, isMockApi: false) {  detailById in
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
                self.imageName = "Like-Wishlist-Filled"
            } else {
                self.imageName = "Like-Wishlist"
            }
            // Update the button image
            let image = UIImage(named: self.imageName)
            self.favorite.setImage(image, for: .normal)
        }
        detailVM.presentAlert = { [weak self] title, message, completion in
            self?.showAlert(title: title, message: message, completion: completion)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: IBAction
    @IBAction func favoriteAction(_ sender: UIButton) {
        APIService().refreshTokenIfNeeded { [weak self] in
            self?.putFavorite()
        } onError: { errorMessage in
            print(errorMessage)
        }
    }
    @IBAction func viewAllReviewAction(_ sender: UIButton) {
        guard let performReviews = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "ReviewsViewController") as? ReviewsViewController else { return }
        performReviews.idProduct = productId
        self.navigationController?.pushViewController(performReviews, animated: true)
    }
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addToCartAction(_ sender: UIButton) {
        print("AddToCartAction")
        guard let idSize = idSizeChoose else {
            print("id for size is nil")
            showAlert(title: "Sorry!", message: "Please choose your size product")
            return
        }
        self.detailVM.addToCart(isMockApi: false, productId: productId!, sizeId: idSize, accessTokenKey: APIService().token!) { _ in
        }
    }
    
    //MARK: FUNCTIONS
    func putFavorite() {
        detailVM.putFavorite(isMockApi: false, accessTokenKey: APIService().token!, productId: productId!) { [weak self] updateWishlist in
            DispatchQueue.main.async {
                self?.updateWishlist = updateWishlist
                if let message = self?.updateWishlist?.data {
                    if message == "successfully delete wishlist" {
                        self?.imageName = "Like-Wishlist"
                    } else if message == "successfully added wishlist" {
                        self?.imageName = "Like-Wishlist-Filled"
                    } else {
                        self?.imageName = "Like-Wishlist"
                    }
                } else {
                    self?.imageName = "Like-Wishlist"
                }
                // Update the button image
                let image = UIImage(named: self?.imageName ?? "Like-Wishlist")
                self?.favorite.setImage(image, for: .normal)
                // Show an alert if needed
                if let message = self?.updateWishlist?.data {
                    self?.showAlert(title: "Wishlist Update", message: message)
                }
            }
        }
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
    func isProductInWishlists(completion: @escaping (Bool) -> Void) {
        APIService().refreshTokenIfNeeded { [weak self] in
            self?.favoriteVM.getFavoriteList(isMockApi: false, accessTokenKey: APIService().token!) { [weak self] wishlist in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.wishlist = wishlist.data
                    guard let productId = self.productId else { return }
                    guard let products = wishlist.data.products else { return }
                    print(productId)
                    print(products)
                    if ((products.contains(where: { productWishlist in
                        productWishlist.id == productId
                    }))) {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        } onError: { errorMessage in
            print(errorMessage)
        }
    }
    func setProduct() {
        imageProduct.setImageWithPlugin(url: (detailProductData?.data.imageURL)!)
        categoryBrand.text = detailProductData?.data.category.category.capitalized
        titleBarang.text = detailProductData?.data.name
        priceLabel.text = "Rp \(detailProductData?.data.price ?? 0)"
        descriptionLabel.text = detailProductData?.data.description
        if let reviews = detailProductReviews.first {
            ratingLabel.text = String(reviews.rating)
            ratingStarData(rating: Double(reviews.rating))
            commentTime.text = DateTimeUtils.shared.formatReview(date: reviews.createdAt)
            commentName.text = reviews.fullName
            commentReview.text = reviews.comment
        }
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
        if indexPath == selectedIndexPath {
            cell.viewSize.backgroundColor = UIColor(hex: "#9775FA")
            cell.labelSize.textColor = .white
        } else {
            cell.viewSize.backgroundColor = UIColor(named: "colorbrand")
            cell.labelSize.textColor = UIColor(named: "FontSetColor")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let selectedProduct = detailProductSize[indexPath.row]
        
        self.idSizeChoose = selectedProduct.id
        print("ketika pilihan size diklik isinya:", String(idSizeChoose!))
        collectionView.reloadData()
    }
}
