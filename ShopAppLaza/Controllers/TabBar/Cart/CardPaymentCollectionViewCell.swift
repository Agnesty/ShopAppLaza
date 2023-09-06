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
    
    private let creditCard: CreditCardFormView = {
        let card = CreditCardFormView()
        card.translatesAutoresizingMaskIntoConstraints = false
        return card
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCard()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCard()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setupCard() {
           contentView.addSubview(creditCard)
           NSLayoutConstraint.activate([
               creditCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
               creditCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
               creditCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
               creditCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
           ])
       }
    
    //MARK: FUNCTION
    func configureData(card: CardModel) {
        let cardOwner = card.ownerCard
        let cardNumber = card.numberCard
        let expMonth = card.expMonthCard
        let expYear = card.expYearCard
        let cvc = card.cvvCard
        
        creditCard.paymentCardTextFieldDidChange(cardNumber: cardNumber, expirationYear: UInt(expYear), expirationMonth: UInt(expMonth), cvc: cvc)
        creditCard.cardHolderString = cardOwner
    }
    
//    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
//        cardPayment.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: UInt(textField.expirationYear), expirationMonth: UInt(textField.expirationMonth), cvc: textField.cvc)
//    }
//
//    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
//        cardPayment.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
//    }
//
//    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
//        cardPayment.paymentCardTextFieldDidBeginEditingCVC()
//    }
//
//    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
//        cardPayment.paymentCardTextFieldDidEndEditingCVC()
//    }
}
