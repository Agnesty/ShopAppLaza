//
//  NewArraivalCollectionViewCell.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 27/07/23.
//

import UIKit
import SDWebImage

class NewArraivalCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "newarraival"
    static func nib() -> UINib {
        return UINib(nibName: "NewArraivalCollectionViewCell", bundle: nil)
    }

    @IBOutlet weak var titleProduk: UILabel!
    @IBOutlet weak var priceProduk: UILabel!
    @IBOutlet weak var imageProduct: UIImageView! {
        didSet{
            imageProduct.layer.cornerRadius = CGFloat(15)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setImageWithPlugin(url: String) {
        let urlImage = URL(string: url)
        imageProduct.sd_setImage(with: urlImage)
    }
    
    

}
