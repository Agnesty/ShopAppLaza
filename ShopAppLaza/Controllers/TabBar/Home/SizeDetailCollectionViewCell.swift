//
//  SizeDetailCollectionViewCell.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 03/08/23.
//

import UIKit

class SizeDetailCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "sizeCollection"
    static func nib() -> UINib {
        return UINib(nibName: "SizeDetailCollectionViewCell", bundle: nil)
    }

    @IBOutlet weak var viewSize: UIView! {
        didSet{
            viewSize.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var labelSize: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
