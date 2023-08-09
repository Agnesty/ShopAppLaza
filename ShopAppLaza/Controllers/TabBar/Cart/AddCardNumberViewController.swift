//
//  AddCardNumberViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 07/08/23.
//

import UIKit
import CreditCardForm
import Stripe

class AddCardNumberViewController: UIViewController, STPPaymentCardTextFieldDelegate {
    
    //MARK: IBOutlet
    @IBOutlet weak var cardView: CreditCardFormView!
    @IBOutlet weak var cardOwnerTF: STPPaymentCardTextField!{
        didSet{
            cardOwnerTF.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    //MARK: IBAction
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
           cardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: UInt(textField.expirationYear), expirationMonth: UInt(textField.expirationYear), cvc: textField.cvc)
       }
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        cardView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: UInt(textField.expirationYear))
    }
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        cardView.paymentCardTextFieldDidBeginEditingCVC()
    }
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        cardView.paymentCardTextFieldDidEndEditingCVC()
    }
    
    
}
