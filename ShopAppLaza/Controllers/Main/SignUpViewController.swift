//
//  SignUpViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 26/07/23.
//

import UIKit

class SignUpViewController: UIViewController {
    
    //IBOutlet
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
    @IBOutlet weak var emailError: UILabel!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var passwordError: UILabel!
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hidePassword(_ sender: UIButton) {
        hideEyePass(object: passwordTF, sender: sender)
    }
    
    @IBAction func hideConfirmPass(_ sender: UIButton) {
        hideEyePass(object: confirmPassTF, sender: sender)
    }
    
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
    
    func hideEyePass(object: UITextField, sender: UIButton) {
        let isHidden = object.isSecureTextEntry
        object.isSecureTextEntry = !isHidden
        
        let imageName = isHidden ? "ic_hide_pass" : "ic_view_pass"
        sender.setImage(UIImage(named: imageName), for: .normal)
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
        checkFormValidation()
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
        checkFormValidation()
        }
    }
    
    func checkFormValidation() {
        if !emailError.isHidden, !passwordError.isHidden {
            signUp.isEnabled = false
            emailCheck.isHidden = true
        } else {
            signUp.isEnabled = true
            emailCheck.isHidden = false
        }
    }
    
    func resetForm() {
        signUp.isEnabled = false
        emailError.isHidden = false
        passwordError.isHidden = false
        emailError.text = "Required"
        passwordError.text = "Required"
        emailTF.text = ""
        passwordTF.text = ""
    }
    
    @objc func disabledBtn(){
        
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
    
    @IBAction func signUpAction(_ sender: UIButton) {
        signUpUser()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        signUp.isEnabled = false
        
        usernameTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        emailTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        passwordTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
        confirmPassTF.addTarget(self, action: #selector(disabledBtn), for: .editingChanged)
    }
    
    private func signUpUser() {
        // Prepare the data to be sent in JSON format
        let userData: [String: Any] = [
            "username": usernameTF.text ?? "",
            "email": emailTF.text ?? "",
            "confirmPass": confirmPassTF.text ?? ""
        ]

        // Convert the user data to JSON
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
            var request = URLRequest(url: URL(string: "https://fakestoreapi.com/users")!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            // Send the request
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    // Handle error here (e.g., show an alert)
                    return
                }

                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        print("Response JSON: \(json)")

                        if let jsonResponse = json as? [String: Any], let userID = jsonResponse["id"] as? Int {
                            DispatchQueue.main.async {
                                // Save the user ID to UserDefaults
                                UserDefaults.standard.set(userID, forKey: "userID")
                                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                UserDefaults.standard.set(userData, forKey: "userData")
                                UserDefaults.standard.synchronize()

                                // Get and print the saved data from UserDefaults
                                if let savedData = UserDefaults.standard.object(forKey: "userData") as? [String: Any] {
                                    print("Data saved in UserDefaults:")
                                    for (key, value) in savedData {
                                        print("\(key): \(value)")
                                    }
                                }
                                self.showAlert(title: "Sign-Up Successful", message: "Congratulations! You have successfully signed up.") {
                                    self.goToHome()
                                }
                            }
                            
                        }

                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            }.resume()
        } catch {
            print("Error creating JSON data: \(error)")
        }
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true, completion: nil)
    }
    
    func goToHome() {
        guard let signUpAction = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarControllerViewController") as? TabBarControllerViewController else { return }
        self.navigationController?.pushViewController(signUpAction, animated: true)
        signUpAction.navigationItem.hidesBackButton = true
    }

}
