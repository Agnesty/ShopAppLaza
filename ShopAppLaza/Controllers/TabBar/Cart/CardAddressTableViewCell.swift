//
//  CardAddressTableViewCell.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 09/08/23.
//

import UIKit

class CardAddressTableViewCell: UITableViewCell {
    
    static let identifier = "cardAddress"
    static func nib() -> UINib {
        return UINib(nibName: "CardAddressTableViewCell", bundle: nil)
    }
    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            viewContainer.layer.cornerRadius = CGFloat(10)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
