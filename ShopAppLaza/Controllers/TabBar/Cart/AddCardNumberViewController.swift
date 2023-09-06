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
    
    var coredataManager = CoreDataManager()
    var creditCardNumber: String?
    var edit: Bool?
    
    //MARK: IBOutlet
    @IBOutlet weak var cardView: CreditCardFormView!
    @IBOutlet weak var cardOwnerTF: STPPaymentCardTextField!{
        didSet{
            cardOwnerTF.delegate = self
        }
    }
    @IBOutlet weak var ownerTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let previousValue = creditCard{
//
//        }
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        coredataManager.presentAlertFailed = {
            self.showAlert(title: "Card Already Exists", message: "Card with this number already exists.")
        }
        coredataManager.presentAlertSucces = {
            self.showAlert(title: "Card Created", message: "Card has been successfully created.") {
                self.navigationController?.popViewController(animated: true)
            }
        }
        coredataManager.presentAlertUpdateSucces = {
            self.showAlert(title: "Card Updated", message: "Card has been successfully created.")
        }
        coredataManager.presentAlertUpdateFailed = {
            self.showAlert(title: "Card Can't Updated", message: "Failed to update data card.")
        }
    }
    
    //MARK: IBAction
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func confirmCard(_ sender: UIButton) {
        let card = CardModel(
            ownerCard: ownerTF.text!,
            numberCard: cardOwnerTF.cardNumber!,
            cvvCard: cardOwnerTF.cvc!,
            expMonthCard: String(cardOwnerTF.expirationMonth),
            expYearCard: String(cardOwnerTF.expirationYear)
        )
        if edit == true {
            if let ccNumber = creditCardNumber {
                coredataManager.updateData(card, numberCard: ccNumber)
                edit = false
            }
        } else {
            coredataManager.create(card)
        }
    }
    
    //MARK: FUNCTION
//    func saveToCoreData() {
//        let card = CardModel(
//            ownerCard: ownerTF.text!,
//            numberCard: cardOwnerTF.cardNumber!,
//            cvvCard: cardOwnerTF.cvc!,
//            expMonthCard: String(cardOwnerTF.expirationMonth),
//            expYearCard: String(cardOwnerTF.expirationYear))
//
//        coredataManager.create(card)
//    }
    
    
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
