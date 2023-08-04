//
//  ForgotPasswordViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 26/07/23.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var labelError: UILabel!
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var emailCheck: UIButton!{
        didSet{
            emailCheck.isHidden = true
        }
    }
    @IBAction func emailChanged(_ sender: Any) {
        if let email = emailTF.text
        {
            if let errorMessage = Regex.shared.invalidEmail(email) {
                labelError.text = errorMessage
                labelError.isHidden = false
            } else {
                labelError.isHidden = true
            }
        }
        
        checkFormValidation()
    }
    
    func checkFormValidation() {
        if !labelError.isHidden {
            confirmBtn.isEnabled = false
            emailCheck.isHidden = true
        } else {
            confirmBtn.isEnabled = true
            emailCheck.isHidden = false
        }
    }
    
    func resetForm() {
        confirmBtn.isEnabled = false
        labelError.isHidden = false
        labelError.text = "Required"
        emailTF.text = ""
    }
    
    @IBAction func confirmAction(_ sender: UIButton) {
        resetForm()
        guard let performVerifCode = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerificationCodeViewController") as? VerificationCodeViewController else { return }
        self.navigationController?.pushViewController(performVerifCode, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        confirmBtn.isEnabled = false
        
        emailTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
    }

    @objc func disabledBtn(){
        if !emailTF.hasText || !labelError.isHidden {
            confirmBtn.isEnabled = false
            confirmBtn.backgroundColor = UIColor(hex: "#8E8E93")
            return
        } else {
            confirmBtn.isEnabled = true
            confirmBtn.backgroundColor = UIColor(hex: "#9775FA")
        }
       
        
    }
    
}
