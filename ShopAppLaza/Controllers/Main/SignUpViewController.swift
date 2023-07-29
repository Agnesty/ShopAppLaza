//
//  SignUpViewController.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 26/07/23.
//

import UIKit

class SignUpViewController: UIViewController {
    
    //IBOutlet
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    
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
    
    @IBAction func signUpAction(_ sender: UIButton) {
        signUpUser()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func signUpUser() {
        // Prepare the data to be sent in JSON format
        let userData: [String: Any] = [
            "firstName": firstNameTF.text ?? "",
            "lastName": lastNameTF.text ?? "",
            "username": usernameTF.text ?? "",
            "email": emailTF.text ?? "",
            "phoneNo": phoneTF.text ?? ""
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
