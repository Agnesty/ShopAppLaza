//
//  BrandCollectionViewCell.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 28/07/23.
//

import UIKit

class BrandCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "brandCollection"
    static func nib() -> UINib {
        return UINib(nibName: "BrandCollectionViewCell", bundle: nil)
    }

    @IBOutlet weak var view: UIView!{
        didSet{
            view.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var labelBrand: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
