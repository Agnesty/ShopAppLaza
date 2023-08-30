//
//  VerifyEmailViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 28/08/23.
//

import UIKit

class VerifyEmailViewController: UIViewController {
    
    private let verifyVM = verifyEmailViewModel()
    
    //MARK: IBOutlet
    @IBOutlet weak var sendMailBtn: UIButton!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var labelError: UILabel!
    @IBOutlet weak var checkBtn: UIButton!{
        didSet{
            checkBtn.isHidden = true
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendMailBtn.isEnabled = false
        emailTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        verifyVM.presentAlert = { [weak self] title, message, completion in
            self?.showAlert(title: title, message: message, completion: completion)
        }
    }
    
    @objc func disabledBtn(){
        if !emailTF.hasText || !labelError.isHidden {
            sendMailBtn.isEnabled = false
            sendMailBtn.backgroundColor = UIColor(hex: "#8E8E93")
            return
        } else {
            sendMailBtn.isEnabled = true
            sendMailBtn.backgroundColor = UIColor(hex: "#9775FA")
        }
    }
    
    //MARK: IBAction
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func emailChanged(_ sender: UITextField) {
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
    
    @IBAction func sendEmailAction(_ sender: UIButton) {
        viewLoading.isHidden = false
        indicatorLoading.isHidden = false
        indicatorLoading.startAnimating()
        DispatchQueue.main.async {
            self.verifyVM.loading = {
                self.viewLoading.isHidden = true
                self.indicatorLoading.isHidden = true
                self.indicatorLoading.stopAnimating()
            }
        }
        verifyVM.verifyEmailUser(email: emailTF.text!, isMockApi: false)
        resetForm()
    }
    
    //MARK: FUNCTION
    func checkFormValidation() {
        if !labelError.isHidden {
            sendMailBtn.isEnabled = false
            checkBtn.isHidden = true
        } else {
            sendMailBtn.isEnabled = true
            checkBtn.isHidden = false
        }
    }
    func resetForm() {
        sendMailBtn.isEnabled = false
        labelError.isHidden = false
        labelError.text = "Required"
        emailTF.text = ""
    }
    
}
