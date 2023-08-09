//
//  CardPaymentCollectionViewCell.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 08/08/23.
//

import UIKit
import CreditCardForm

class CardPaymentCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "cardPayment"
    static func nib() -> UINib {
        return UINib(nibName: "CardPaymentCollectionViewCell", bundle: nil)
    }
    
    //MARK: IBOutlet
    
    @IBOutlet weak var cardPayment: CreditCardFormView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: IBAction

}
