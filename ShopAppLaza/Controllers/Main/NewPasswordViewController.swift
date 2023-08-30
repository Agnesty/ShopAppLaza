//
//  NewPasswordViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 26/07/23.
//

import UIKit

class NewPasswordViewController: UIViewController {
    var email: String?
    var code: String?
    
    private var newPasswordVM = NewPasswordViewModel()
    
    //MARK: IBOutlet
    @IBOutlet weak var passwordTF: UITextField!{
        didSet{
            passwordTF.borderStyle = .none
        }
    }
    @IBOutlet weak var confirmPassTF: UITextField!{
        didSet{
            confirmPassTF.borderStyle = .none
        }
    }
    @IBOutlet weak var resetPassBtn: UIButton!
    @IBOutlet weak var strongCheck: UILabel!{
        didSet{
            strongCheck.isHidden = true
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
        navigationItem.hidesBackButton = true
        resetPassBtn.isEnabled = false
        confirmPassTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        newPasswordVM.navigateToLogin = { [weak self] in
            self?.goToLogin()
        }
        newPasswordVM.presentAlert = { [weak self] title, message, completion in
            self?.showAlert(title: title, message: message, completion: completion)
        }
    }
    
    //MARK: IBAction
    @IBAction func resetPassAction(_ sender: UIButton) {
        viewLoading.isHidden = false
        indicatorLoading.isHidden = false
        indicatorLoading.startAnimating()
        DispatchQueue.main.async {
            self.newPasswordVM.loading = {
                self.viewLoading.isHidden = true
                self.indicatorLoading.isHidden = true
                self.indicatorLoading.stopAnimating()
            }
        }
        newPasswordVM.newPassword(newPass: passwordTF.text!, rePassword: confirmPassTF.text!, email: email!, code: code!, isMockApi: false)
        
    }
    @IBAction func hidePassButton(_ sender: UIButton) {
        hideEyePass(object: passwordTF, sender: sender)
    }
    @IBAction func hideConfirmPass(_ sender: UIButton) {
        hideEyePass(object: confirmPassTF, sender: sender)
    }
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func disabledBtn(){
        //Memunculkan Strong Check pada Password
        let strongCheck = passwordTF.text ?? ""
        let validStrong = strongCheck.count > 8
        resetPassBtn.isEnabled = strongCheck.count > 8
        if validStrong {
            self.strongCheck.isHidden = false
        } else {
            self.strongCheck.isHidden = true
        }
        
        //Jika text belum diisi pada textfield maka tombol belum bisa diklik
        if !confirmPassTF.hasText, !passwordTF.hasText {
            resetPassBtn.isEnabled = false
            resetPassBtn.backgroundColor = UIColor(hex: "#8E8E93")
            resetPassBtn.titleLabel?.textColor = .systemBackground
            return
        }
        
        //Jika password dan confirmPass sama, buttonnya baru bisa diklik
        if confirmPassTF.text == passwordTF.text{
            resetPassBtn.isEnabled = true
            resetPassBtn.backgroundColor = UIColor(hex: "#9775FA")
        } else  {
            resetPassBtn.isEnabled = false
            resetPassBtn.backgroundColor = UIColor(hex: "#8E8E93")
            resetPassBtn.tintColor = .white
        }
    }
    
    //MARK: FUNCTION
    func hideEyePass(object: UITextField, sender: UIButton) {
        let isHidden = object.isSecureTextEntry
        object.isSecureTextEntry = !isHidden
        
        let imageName = isHidden ? "ic_hide_pass" : "ic_view_pass"
        sender.setImage(UIImage(named: imageName), for: .normal)
    }
    func goToLogin() {
        guard let loginAction = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        self.navigationController?.pushViewController(loginAction, animated: true)
        loginAction.navigationItem.hidesBackButton = true
    }
}
