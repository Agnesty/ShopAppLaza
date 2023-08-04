//
//  DetailViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 31/07/23.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    let sizes = ["S", "M", "L", "XL", "2XL"]
    enum Star: String {
        case fullStar = "star.fill"
        case halfStar = "star.leadinghalf.filled"
        case emptyStar = "star"
    }
    
    var product: WelcomeElement?
    
    @IBOutlet weak var viewAllReviews: UIButton!
    @IBOutlet weak var sizeCollection: UICollectionView!
    @IBAction func viewAllReviewAction(_ sender: UIButton) {
        guard let performReviews = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "ReviewsViewController") as? ReviewsViewController else { return }
        self.navigationController?.pushViewController(performReviews, animated: true)
    }
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.hidesBackButton = true
        
        sizeCollection.dataSource = self
        sizeCollection.delegate = self
        sizeCollection.register(SizeDetailCollectionViewCell.nib(), forCellWithReuseIdentifier: SizeDetailCollectionViewCell.identifier)
        sizeCollection.reloadData()
        
        setProduct()
        ratingStarData(rating: product?.rating.rate ?? 0)
   
    }
    
    func setProduct() {
        imageSetURL(url: (product?.image)!)
        self.categoryBrand.text = product?.category.rawValue.capitalized
        self.titleBarang.text = product?.title
        self.priceLabel.text = "$\(product?.price ?? 0)"
        self.descriptionLabel.text = product?.description
        self.ratingLabel.text = "\(product?.rating.rate ?? 0)"
    }
    
    func imageSetURL(url: String) {
        let urlImage = URL(string: url)
        imageProduct.sd_setImage(with: urlImage)
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
        return sizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SizeDetailCollectionViewCell.identifier, for: indexPath) as? SizeDetailCollectionViewCell else {
            return UICollectionViewCell() }
        cell.labelSize.text = sizes[indexPath.row]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 60, height: 60)
    }
    
    
    
    
    
    
}
