//
//  SignUpViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 26/07/23.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private let signUpVM = SignUpViewModel()
    
    //MARK: IBOutlet
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var passwordError: UILabel!
    @IBOutlet weak var usernameCheck: UIButton!{
        didSet{
            usernameCheck.isHidden = true
        }
    }
    @IBOutlet weak var emailCheck: UIButton!{
        didSet{
            emailCheck.isHidden = true
        }
    }
    @IBOutlet weak var strongCheck: UILabel!{
        didSet{
            strongCheck.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        signUpVM.signUpViewCtr = self
        signUp.isEnabled = false
        usernameTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        emailTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        confirmPassTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
    }
    
    //MARK: IBAction
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func hidePassword(_ sender: UIButton) {
        hideEyePass(object: passwordTF, sender: sender)
    }
    @IBAction func hideConfirmPass(_ sender: UIButton) {
        hideEyePass(object: confirmPassTF, sender: sender)
    }
    @IBAction func emailChanged(_ sender: Any) {
        if let email = emailTF.text
        {
            if let errorMessage = Regex.shared.invalidEmail(email) {
                emailError.text = errorMessage
                emailError.isHidden = false
            } else {
                emailError.isHidden = true
            }
        }
    }
    @IBAction func passwordEditingChanged(_ sender: UITextField) {
        if let password = passwordTF.text
        {
            if let errorMessage = Regex.shared.invalidPassword(password) {
                passwordError.text = errorMessage
                passwordError.isHidden = false
            } else {
                passwordError.isHidden = true
                
            }
        }
    }
    @IBAction func signUpAction(_ sender: UIButton) {
        signUpVM.signUpUser()
    }
    
    @objc func disabledBtn(){
        //Pemunculan label error pada email dan password
        if !emailError.isHidden, !passwordError.isHidden {
            signUp.isEnabled = false
            emailCheck.isHidden = true
        } else {
            signUp.isEnabled = true
            emailCheck.isHidden = false
        }
        
        //Memunculkan check pada username
        let username = usernameTF.text ?? ""
        let validUsername = username.count > 4
        signUp.isEnabled = username.count > 4
        if validUsername{
            usernameCheck.isHidden = false
        } else {
            usernameCheck.isHidden = true
        }
        
        //Jika sesuai kategori kebutuhan dari setiap textfield maka signup button akan terbuka
        if !usernameTF.hasText || !emailTF.hasText || !emailError.isHidden || !passwordTF.hasText || !passwordError.isHidden || !confirmPassTF.hasText  {
            signUp.isEnabled = false
            signUp.backgroundColor = UIColor(hex: "#8E8E93")
        } else {
            signUp.isEnabled = true
            signUp.backgroundColor = UIColor(hex: "#9775FA")
        }
    }
    
    //MARK: FUNCTION
    //Buka tutup password
    func hideEyePass(object: UITextField, sender: UIButton) {
        let isHidden = object.isSecureTextEntry
        object.isSecureTextEntry = !isHidden
        
        let imageName = isHidden ? "ic_hide_pass" : "ic_view_pass"
        sender.setImage(UIImage(named: imageName), for: .normal)
    }
    //Beberapa yang perlu direset kembali ketika sudah berhasil signup
    func resetForm() {
        signUp.isEnabled = false
        emailError.isHidden = false
        passwordError.isHidden = false
        emailError.text = "Required"
        passwordError.text = "Required"
        emailTF.text = ""
        passwordTF.text = ""
    }
    //Memunculkan alert
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true, completion: nil)
    }
    //SignUp berhasil
    func goToHome() {
        resetForm()
        guard let signUpAction = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarControllerViewController") as? TabBarControllerViewController else { return }
        self.navigationController?.pushViewController(signUpAction, animated: true)
        signUpAction.navigationItem.hidesBackButton = true
    }

}
