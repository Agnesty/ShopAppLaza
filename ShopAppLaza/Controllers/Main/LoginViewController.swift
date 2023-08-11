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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        loginVM.loginViewCtr = self
        loginBtn.isEnabled = false
        usernameTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
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
    @IBAction func loginAction(_ sender: UIButton) {
        guard let username = usernameTF.text else { return }
        guard let password = passwordTF.text else { return }
        loginVM.login(username: username, password: password)
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
    func loginSuccessful(user: UserElement) {
        // Navigasi ke halaman beranda
        let homeViewController = HomeController()
        homeViewController.loggedInUser = user // Mengirim data user ke halaman beranda jika diperlukan
        guard let loginAction = UIStoryboard(name: "TabBar",bundle:nil).instantiateViewController(withIdentifier:"TabBarControllerViewController") as? TabBarControllerViewController else { return }
        loginAction.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(loginAction,animated: true)
        self.navigationController?.navigationBar.isHidden = true
        
        // Menampilkan pesan selamat datang
        let welcomeMessage = "Welcome, \(user.username)!"
        let alert = UIAlertController(title: "Login Successful", message: welcomeMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.view.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
        // Menyimpan status login untuk digunakan di seluruh aplikasi
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(user.email, forKey: "loggedInEmail")
        UserDefaults.standard.set(user.username, forKey: "loggedInUsername")
        UserDefaults.standard.set(user.password, forKey: "loggedInPassword")
        UserDefaults.standard.set(user.name.firstname, forKey: "loggedInFirstName")
        UserDefaults.standard.synchronize()
    }
        
    func showLoginError() {
        // Tampilkan pesan error, misalnya dengan alert
        let alert = UIAlertController(title: "Login Failed", message: "Invalid username or password", preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
