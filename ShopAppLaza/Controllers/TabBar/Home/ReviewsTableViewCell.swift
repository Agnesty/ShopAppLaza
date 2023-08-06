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
    @IBOutlet weak var textReviews: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
