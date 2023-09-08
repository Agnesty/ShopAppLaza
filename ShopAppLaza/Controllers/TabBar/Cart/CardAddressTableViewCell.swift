//
//  CardAddressTableViewCell.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 09/08/23.
//

import UIKit

protocol deleteAddressProtocol: AnyObject {
    func deleteAddress(cell: CardAddressTableViewCell)
    func editAddress(cell: CardAddressTableViewCell)
}

class CardAddressTableViewCell: UITableViewCell {
    
    static let identifier = "cardAddress"
    static func nib() -> UINib {
        return UINib(nibName: "CardAddressTableViewCell", bundle: nil)
    }
    weak var delegate: deleteAddressProtocol?
    
    //MARK: IBOutlet
    @IBOutlet weak var viewContainer: UIView!{
        didSet{
            viewContainer.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var receiveName: UILabel!
    @IBOutlet weak var phoneNo: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var labelCountry: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.contentView.backgroundColor = isSelected ? UIColor(named: "BG") : UIColor(named: "BG")
    }
    
    //MARK: IBAction
    
    @IBAction func editAddress(_ sender: UIButton) {
        delegate?.editAddress(cell: self)
    }
    
    @IBAction func deleteAddress(_ sender: UIButton) {
        delegate?.deleteAddress(cell: self)
    }
    
}
