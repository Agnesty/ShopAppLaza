//
//  PaymentMethodViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 09/08/23.
//

import UIKit

class PaymentMethodViewController: UIViewController {
    
    var contentCheckGopay = false
    var contentCheckCreditCard = false
    
    //MARK: IBOutlet
    @IBOutlet weak var viewGopay: UIView!{
        didSet{
            viewGopay.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var viewCreditCard: UIView!{
        didSet{
            viewCreditCard.layer.cornerRadius = CGFloat(10)
        }
    }
    @IBOutlet weak var gopayCheck: UIButton!
    @IBOutlet weak var creditCardCheck: UIButton!
    @IBOutlet weak var savePaymentBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func gopayAction(_ sender: UIButton) {
        if gopayCheck.currentImage == UIImage(systemName: "square") {
           gopayCheck.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
           creditCardCheck.setImage(UIImage(systemName: "square"), for: .normal)
           viewGopay.backgroundColor = UIColor(named: "boxchecked")
           viewCreditCard.backgroundColor = UIColor(named: "Checkcolorview")
            contentCheckGopay = true
            contentCheckCreditCard = false
            savePaymentBtn.isEnabled = true
            savePaymentBtn.backgroundColor = UIColor(hex: "#9775FA")
         } else if gopayCheck.currentImage == UIImage(systemName: "checkmark.square") {
             contentCheckGopay = false
             gopayCheck.setImage(UIImage(systemName: "square"), for: .normal)
             viewGopay.backgroundColor = UIColor(named: "Checkcolorview")
             savePaymentBtn.isEnabled = false
             savePaymentBtn.backgroundColor = UIColor(hex: "#8E8E93")
         }
    }
    @IBAction func creditcardAction(_ sender: UIButton) {
        if creditCardCheck.currentImage == UIImage(systemName: "square") {
             creditCardCheck.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            contentCheckCreditCard = true
            contentCheckGopay = false
             gopayCheck.setImage(UIImage(systemName: "square"), for: .normal)
             viewCreditCard.backgroundColor = UIColor(named: "boxchecked")
             viewGopay.backgroundColor = UIColor(named: "Checkcolorview")
            savePaymentBtn.isEnabled = true
            savePaymentBtn.backgroundColor = UIColor(hex: "#9775FA")
           } else if creditCardCheck.currentImage == UIImage(systemName: "checkmark.square") {
               contentCheckCreditCard = false
               creditCardCheck.setImage(UIImage(systemName: "square"), for: .normal)
               viewCreditCard.backgroundColor = UIColor(named: "Checkcolorview")
               savePaymentBtn.isEnabled = false
               savePaymentBtn.backgroundColor = UIColor(hex: "#8E8E93")
           }
    }
    @IBAction func savePaymentAction(_ sender: UIButton) {
        if contentCheckGopay {
            guard let performGopayPayment = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "GopayPaymentViewController") as? GopayPaymentViewController else { return }
            self.navigationController?.pushViewController(performGopayPayment, animated: true)
        } else if contentCheckCreditCard {
            guard let performCreditCardPayment = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "AddCardNumberViewController") as? AddCardNumberViewController else { return }
            self.navigationController?.pushViewController(performCreditCardPayment, animated: true)
        }
        
    }
    
}
