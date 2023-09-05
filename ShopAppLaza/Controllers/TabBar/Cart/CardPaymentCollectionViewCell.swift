//
//  CardPaymentCollectionViewCell.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 08/08/23.
//

import UIKit
import CreditCardForm
import StripePaymentsUI

class CardPaymentCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "cardPayment"
    static func nib() -> UINib {
        return UINib(nibName: "CardPaymentCollectionViewCell", bundle: nil)
    }
    var editButtonAction: (() -> Void)?
    
    //MARK: IBOutlet
    @IBOutlet weak var cardPayment: CreditCardFormView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: FUNCTION
    func configureData(card: CardModel) {
        let cardOwner = card.ownerCard
        let cardNumber = card.numberCard
        let expMonth = card.expMonthCard
        let expYear = card.expYearCard
        let cvc = card.cvvCard
        
        cardPayment.paymentCardTextFieldDidChange(cardNumber: cardNumber, expirationYear: UInt(expYear), expirationMonth: UInt(expMonth), cvc: cvc)
        cardPayment.cardHolderString = cardOwner
    }
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        cardPayment.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: UInt(textField.expirationYear), expirationMonth: UInt(textField.expirationMonth), cvc: textField.cvc)
        
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        cardPayment.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        cardPayment.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        cardPayment.paymentCardTextFieldDidEndEditingCVC()
    }
}
