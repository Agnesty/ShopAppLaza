//
//  ReviewsTableViewCell.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 03/08/23.
//

import UIKit
import SDWebImage

class ReviewsTableViewCell: UITableViewCell {
    static let identifier = "reviewsTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "ReviewsTableViewCell", bundle: nil)
    }
    
    //MARK: IBOutlet
    @IBOutlet weak var imageUser: UIImageView!{
        didSet{
            imageUser.layer.cornerRadius = CGFloat(20)
        }
    }
    @IBOutlet weak var peopleName: UILabel!
    @IBOutlet weak var waktuReview: UILabel!
    @IBOutlet weak var reviews: UILabel!
    @IBOutlet weak var textReviews: UILabel!{
        didSet{
            textReviews.textAlignment = .justified
        }
    }
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: FUNCTIONS
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
