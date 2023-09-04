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
        
        coredataManager.presentAlertFailed = {
            self.showAlert(title: "Data Already Exists", message: "Data with species \(self.cardOwnerTF.cardNumber!) already exists in Core Data.")
        }
        coredataManager.presentAlertSucces = {
            self.showAlert(title: "Data Created", message: "Data has been successfully created.")
        }
    
        coredataManager.navigateToBack = {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: IBAction
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func confirmCard(_ sender: UIButton) {
        guard let ccNumber = creditCardNumber else { print("kosong")
            return
        }
        
        let card = CardModel(
            ownerCard: ownerTF.text!,
            numberCard: cardOwnerTF.cardNumber!,
            cvvCard: cardOwnerTF.cvc!,
            expMonthCard: String(cardOwnerTF.expirationMonth),
            expYearCard: String(cardOwnerTF.expirationYear)
        )
        if edit == true {
            coredataManager.updateData(card, numberCard: ccNumber)
            edit = false
        } else {
            coredataManager.create(card)
        }
    }
    
    @IBAction func deleteCard(_ sender: UIButton) {
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
