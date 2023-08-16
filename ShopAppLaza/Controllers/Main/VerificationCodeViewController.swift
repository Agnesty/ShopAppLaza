//
//  VerificationCodeViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 03/08/23.
//

import UIKit

class VerificationCodeViewController: UIViewController, UITextFieldDelegate {
    var userEmail: String?
    
    private var verificationCodeVM = VerficationCodeViewModel()
    
    //MARK: IBOutlet
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    @IBOutlet weak var confirmCodeBtn: UIButton!
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
        confirmCodeBtn.isEnabled = false
        verificationCodeVM.verificationCodeViewCtr = self
        
        tf1.delegate = self
        tf2.delegate = self
        tf3.delegate = self
        tf4.delegate = self
        
        tf1.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        tf2.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        tf3.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        tf4.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
    }
    
    //MARK: IBAction
    @IBAction func confirmCodeAction(_ sender: UIButton) {
        viewLoading.isHidden = false
        indicatorLoading.isHidden = false
        indicatorLoading.startAnimating()
        DispatchQueue.main.async {
            self.verificationCodeVM.loading = {
                self.viewLoading.isHidden = true
                self.indicatorLoading.isHidden = true
                self.indicatorLoading.stopAnimating()
            }
        }
        verificationCodeVM.verificationCode(email: userEmail!, tf1: tf1.text!, tf2: tf2.text!, tf3: tf3.text!, tf4: tf4.text!)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func disabledBtn() {
        if !tf1.hasText || !tf2.hasText || !tf3.hasText || !tf4.hasText {
            confirmCodeBtn.isEnabled = false
            confirmCodeBtn.backgroundColor = UIColor(hex: "#8E8E93")
            confirmCodeBtn.tintColor = .white
        } else {
            confirmCodeBtn.isEnabled = true
            confirmCodeBtn.backgroundColor =  UIColor(hex: "#9775FA")
        }
    }
    
    //MARK: FUNCTION
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 1
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        // Check for maximum length
        if newString.count > maxLength {
            return false
        }

        // Check for allowed characters (decimal digits)
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }

        return true
    }
    func goToNewPassword(emailHttp: String, codeHttp: String) {
        guard let newPassAction = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewPasswordViewController") as? NewPasswordViewController else { return }
        newPassAction.email = emailHttp
        newPassAction.code = codeHttp
        self.navigationController?.pushViewController(newPassAction, animated: true)
        newPassAction.navigationItem.hidesBackButton = true
    }
}
