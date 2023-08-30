//
//  LoginViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 26/07/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let loginVM = LoginViewModel()
    
    //MARK: IBOutlet
    @IBOutlet weak var usernameTF: UITextField!{
        didSet{
            usernameTF.borderStyle = .none
        }
    }
    @IBOutlet weak var passwordTF: UITextField!{
        didSet{
            passwordTF.borderStyle = .none
        }
    }
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var strongCheck: UILabel!{
        didSet{
            strongCheck.isHidden = true
        }
    }
    @IBOutlet weak var usernameCheck: UIButton!{
        didSet{
            usernameCheck.isHidden = true
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
    @IBOutlet weak var switchRememberMeBtn: UISwitch!{
        didSet{
            switchRememberMeBtn.isOn = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        if let savedUsername = defaults.string(forKey: "savedUsername"),
           let savedPassword = defaults.string(forKey: "savedPassword") {
            usernameTF.text = savedUsername
            passwordTF.text = savedPassword
            }
            
            navigationItem.hidesBackButton = true
            loginBtn.isEnabled = false
            usernameTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
            passwordTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        
        loginVM.presentAlert = { [weak self] title, message, completion in
            self?.showAlert(title: title, message: message, completion: completion)
            }
        loginVM.navigateToHome = { [weak self] in
            self?.goToHome()
            }
        loginVM.navigateToVerifyEmail = { [weak self] in
            self?.goToVerifyEmail()
            }
            
        }
        
        //MARK: IBAction
        @IBAction func backButton(_ sender: UIButton) {
            self.navigationController?.popViewController(animated: true)
        }
        @IBAction func hidePassBtn(_ sender: UIButton) {
            let isHidden = passwordTF.isSecureTextEntry
            passwordTF.isSecureTextEntry = !isHidden
            let imageName = isHidden ? "ic_hide_pass" : "ic_view_pass"
            sender.setImage(UIImage(named: imageName), for: .normal)
        }
        @IBAction func forgotPassAction(_ sender: UIButton) {
            guard let forgotPass = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController else { return }
            self.navigationController?.pushViewController(forgotPass, animated: true)
        }
        @IBAction func rememberMeSwitch(_ sender: UISwitch) {
            let defaults = UserDefaults.standard
            if sender.isOn {
                if let username = usernameTF.text, let password = passwordTF.text {
                    defaults.set(username, forKey: "savedUsername")
                    defaults.set(password, forKey: "savedPassword")
                }
            }
        }
        
        
        @IBAction func loginAction(_ sender: UIButton) {
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            viewLoading.isHidden = false
            indicatorLoading.isHidden = false
            indicatorLoading.startAnimating()
            DispatchQueue.main.async {
                self.loginVM.loading = {
                    self.viewLoading.isHidden = true
                    self.indicatorLoading.isHidden = true
                    self.indicatorLoading.stopAnimating()
                }
            }
            loginVM.loginUser(username: usernameTF.text!, password: passwordTF.text!, isMockApi: false)
        }
        
        @objc func disabledBtn(){
            //Memunculkan Strong Check pada Password
            let strongCheck = passwordTF.text ?? ""
            let validStrong = strongCheck.count > 8
            loginBtn.isEnabled = strongCheck.count > 8
            if validStrong {
                self.strongCheck.isHidden = false
            } else {
                self.strongCheck.isHidden = true
            }
            
            //Memunculkan check pada username
            let username = usernameTF.text ?? ""
            let validUsername = username.count > 4
            loginBtn.isEnabled = username.count > 4
            if validUsername{
                usernameCheck.isHidden = false
            } else {
                usernameCheck.isHidden = true
            }
            
            //Jika sesuai kategori kebutuhan dari setiap textfield maka signup button akan terbuka
            if !usernameTF.hasText || !passwordTF.hasText {
                loginBtn.isEnabled = false
                loginBtn.backgroundColor = UIColor(hex: "#8E8E93")
            } else {
                loginBtn.isEnabled = true
                loginBtn.backgroundColor = UIColor(hex: "#9775FA")
            }
        }
        
        //MARK: FUNCTION
        func goToHome() {
            guard let homeAction = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarControllerViewController") as? TabBarControllerViewController else { return }
            self.navigationController?.pushViewController(homeAction, animated: true)
            homeAction.navigationItem.hidesBackButton = true
        }
        func goToVerifyEmail() {
            guard let verifyAction = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerifyEmailViewController") as? VerifyEmailViewController else { return }
            self.navigationController?.pushViewController(verifyAction, animated: true)
            verifyAction.navigationItem.hidesBackButton = true
        }
    }
