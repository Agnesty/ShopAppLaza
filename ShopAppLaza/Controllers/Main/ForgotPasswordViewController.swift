//
//  ForgotPasswordViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 26/07/23.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    private let forgotPassVM = ForgotPassViewModel()
    
    //MARK: IBOutlet
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var emailTF: UITextField!{
        didSet{
            emailTF.borderStyle = .none
        }
    }
    @IBOutlet weak var labelError: UILabel!
    @IBOutlet weak var emailCheck: UIButton!{
        didSet{
            emailCheck.isHidden = true
        }
    }
    
    @IBOutlet weak var viewLoading: UIView!{
        didSet{
            viewLoading.isHidden = true
        }
    }
    
    @IBOutlet weak var indicatorLoading: UIActivityIndicatorView!{
        didSet{
            indicatorLoading.isHidden = true
        }
    }
    //MARK: IBAction
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    @IBAction func confirmAction(_ sender: UIButton) {
        viewLoading.isHidden = false
        indicatorLoading.isHidden = false
        indicatorLoading.startAnimating()
        DispatchQueue.main.async {
            self.forgotPassVM.loading = {
                self.viewLoading.isHidden = true
                self.indicatorLoading.isHidden = true
                self.indicatorLoading.stopAnimating()
            }
        }
        forgotPassVM.forgotPassSendAPICode(email: emailTF.text!)
        resetForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forgotPassVM.forgotPassViewCtr = self
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
    
    //MARK: FUNCTION
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
    func goToVerificationCode(email: String) {
        guard let verifAction = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerificationCodeViewController") as? VerificationCodeViewController else { return }
        verifAction.navigationItem.hidesBackButton = true
        verifAction.userEmail = email
        self.navigationController?.pushViewController(verifAction, animated: true)
        
    }
    
}
