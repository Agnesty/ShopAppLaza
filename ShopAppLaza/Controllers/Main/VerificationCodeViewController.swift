//
//  VerificationCodeViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 03/08/23.
//

import UIKit

class VerificationCodeViewController: UIViewController, UITextFieldDelegate {
    var userEmail: String?
    var timer = 300
    var countDown: Timer!
    
    private var verificationCodeVM = VerficationCodeViewModel()
    
    //MARK: IBOutlet
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    @IBOutlet weak var confirmCodeBtn: UIButton!
    @IBOutlet weak var timeVerifMessage: UILabel!
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
        
        tf1.delegate = self
        tf2.delegate = self
        tf3.delegate = self
        tf4.delegate = self
        
        tf1.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        tf2.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        tf3.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        tf4.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        
//        let tf1Value = tf1.text!
//        let tf2Value = tf2.text!
//        let tf3Value = tf3.text!
//        let tf4Value = tf4.text!
//        let combinedText = tf1Value + tf2Value + tf3Value + tf4Value
        verificationCodeVM.presentAlert = { [weak self] title, messages, completion in
            self?.showAlert(title: title, message: messages, completion: completion)
        }
        
        verificationCodeVM.navigateToNewPassword = { [weak self] in
            let tf1Value = self!.tf1.text!
            let tf2Value = self!.tf2.text!
            let tf3Value = self!.tf3.text!
            let tf4Value = self!.tf4.text!
            let combinedText = tf1Value + tf2Value + tf3Value + tf4Value
            self?.goToNewPassword(emailHttp: (self?.userEmail)!, codeHttp: combinedText)
        }
        starCountDown()
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
        verificationCodeVM.verificationCode(email: userEmail!, tf1: tf1.text!, tf2: tf2.text!, tf3: tf3.text!, tf4: tf4.text!, isMockApi: false)
        
        //        let tf1 = tf1.text!
        //        let tf2 = tf2.text!
        //        let tf3 = tf3.text!
        //        let tf4 = tf4.text!
        //        let combinedText = tf1 + tf2 + tf3 + tf4
        //        verificationCodeVM.navigateToNewPassword = { [weak self] in
        //            self?.goToNewPassword(emailHttp: (self?.userEmail)!, codeHttp: combinedText)
        //        }
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
    private func starCountDown() {
        countDown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timeVerifMessage.text = "\(timeFormatted(timer))"
        if timer != 0 {
            timer -= 1
        } else {
            countDown.invalidate()
            showAlert(title: "Warning", message: "time is up, send the verification code again") { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        //     let hours: Int = totalSeconds / 3600
        return String(format: "%02d:%02d", minutes, seconds)
    }
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
//                newPassAction.navigationItem.hidesBackButton = true
    }
}
