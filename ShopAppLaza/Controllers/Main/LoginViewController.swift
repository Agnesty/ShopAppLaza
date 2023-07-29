//
//  LoginViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 26/07/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton.init(type: .custom)
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        return backButton
    }()
    
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBAction func forgotPassAction(_ sender: UIButton) {
        guard let forgotPass = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController else { return }
        
        self.navigationController?.pushViewController(forgotPass, animated: true)
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        guard let username = usernameTF.text else { return }
        guard let password = passwordTF.text else { return }
        
        login(username: username, password: password)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        usernameTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        
    }
    
    func login(username: String, password: String) {
        let urlString = "https://fakestoreapi.com/users"
        guard let url = URL(string: urlString) else {
            print("URL not valid")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data else {
                print("Error retrieving data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let users = try JSONDecoder().decode(User.self, from: data)
                // Lakukan pengecekan login berdasarkan username dan password
                if let user = users.first(where: { $0.username == username && $0.password == password }) {
                    // Login berhasil, lakukan tindakan yang diperlukan setelah login
                    DispatchQueue.main.async { [weak self] in
                        self?.loginSuccessful(user: user)
                    }
                } else {
                    // Login gagal, tampilkan pesan error
                    DispatchQueue.main.async { [weak self] in
                        self?.showLoginError()
                    }
                }
                
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func loginSuccessful(user: UserElement) {
        // Navigasi ke halaman beranda
        let homeViewController = HomeViewController()
        homeViewController.loggedInUser = user // Mengirim data user ke halaman beranda jika diperlukan
        guard let loginAction = UIStoryboard(name: "TabBar",bundle:nil).instantiateViewController(withIdentifier:"TabBarControllerViewController") as? TabBarControllerViewController else { return }
        loginAction.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(loginAction,animated: true)
        
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
        
        
        UserDefaults.standard.synchronize()
    }
        
    func showLoginError() {
        // Tampilkan pesan error, misalnya dengan alert
        let alert = UIAlertController(title: "Login Failed", message: "Invalid username or password", preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func disabledBtn(){
        if !usernameTF.hasText || !passwordTF.hasText {
            loginBtn.isEnabled = false
            loginBtn.backgroundColor = .gray
            return
        } else {
            loginBtn.isEnabled = true
            loginBtn.backgroundColor = UIColor(hex: "#9775FA")
        }
       
        
    }
    
    
    
}
