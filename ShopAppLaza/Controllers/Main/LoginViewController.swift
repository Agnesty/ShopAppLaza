//
//  LoginViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 26/07/23.
//

import UIKit

class LoginViewController: UIViewController {
    private let profileVM = ProfilViewModel()
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
            passwordTF.isSecureTextEntry = true
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
        if let savedUsername = UserDefaults.standard.string(forKey: "username"),
           let savedPassword = KeychainManager.keychain.getToken(service: Token.password.rawValue) {
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
            self?.getDataProfile()
        }
        loginVM.navigateToVerifyEmail = { [weak self] in
            self?.goToVerifyEmail()
        }
        profileVM.afterSaveToLocal = { [weak self] in
            self?.goToHome()
        }
    }
    
    //MARK: IBAction
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
        guard let username = usernameTF.text else { return }
        guard let password = passwordTF.text else { return }
        if sender.isOn {
            UserDefaults.standard.set(username, forKey: "username")
            KeychainManager.keychain.saveToken(token: password, service: Token.password.rawValue)
        }
    }
    @IBAction func signUpAction(_ sender: UIButton) {
        guard let performSignUp = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }
        self.navigationController?.pushViewController(performSignUp, animated: true)
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
        homeAction.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(homeAction, animated: true)
    }
    func goToVerifyEmail() {
        guard let verifyAction = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VerifyEmailViewController") as? VerifyEmailViewController else { return }
        verifyAction.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(verifyAction, animated: true)
    }
    func getDataProfile() {
        profileVM.getUserProfile(isMockApi: false, accessTokenKey: APIService().token!) {userdata in
            DispatchQueue.main.async {
                APIService.setCurrentProfile(profile: userdata)
                print("userData di Login Nih: ", userdata)
            }
        }
    }
}
