//
//  TableViewCell.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 29/07/23.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    
    static let identifier = "sideMenu"
    static func nib() -> UINib {
        return UINib(nibName: "SideMenuTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var sideMenuBtn: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
