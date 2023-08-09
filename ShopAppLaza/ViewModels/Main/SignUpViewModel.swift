//
//  SignUpViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 05/08/23.
//

import Foundation
import CryptoKit

class SignUpViewModel {
    private let encryptDescrypt = EncryptDescrypt()
    var signUpViewCtr: SignUpViewController?
    
    func signUpUser() {
        guard let unwrappedVC = signUpViewCtr else { return }
        let key = SymmetricKey(size: .bits256)
        // Prepare the data to be sent in JSON format
        let userData: [String: Any] = [
            "username": unwrappedVC.usernameTF.text ?? "",
            "email": unwrappedVC.emailTF.text ?? "",
            "confirmPass": unwrappedVC.confirmPassTF.text ?? ""
        ]

        // Convert the user data to JSON
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
            let encryptedUserData = try! encryptDescrypt.encryptData(jsonData, using: key)
            let encryptedUserDataBase64 = encryptedUserData.base64EncodedString()
            print("ini encrypt yang awal: \(encryptedUserDataBase64)")
            var request = URLRequest(url: URL(string: "https://fakestoreapi.com/users")!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            // Send the request
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    // Handle error here (showAlert)
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
                                UserDefaults.standard.set(encryptedUserDataBase64, forKey: "userData")
                                UserDefaults.standard.synchronize()

                                // Get and print the saved data from UserDefaults
                                if let savedData = UserDefaults.standard.object(forKey: "userData") as? [String: Any] {
                                    print("Data saved in UserDefaults:")
                                    for (key, value) in savedData {
                                        print("\(key): \(value)")
                                    }
                                }
                                unwrappedVC.showAlert(title: "Sign-Up Successful", message: "Congratulations! You have successfully signed up.") {
                                unwrappedVC.goToHome()
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
}
