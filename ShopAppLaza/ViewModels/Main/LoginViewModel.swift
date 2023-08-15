//
//  LoginViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 05/08/23.
//

import Foundation

class LoginViewModel {
    var loginViewCtr: LoginViewController?
    
    func loginUser() {
        guard let unwrappedVC = loginViewCtr else { return }
        let urlString = "https://lazaapp.shop/login"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let userData: [String: Any] = [
            "username": unwrappedVC.usernameTF.text ?? "",
            "password": unwrappedVC.passwordTF.text ?? "",
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = SignUpViewModel.getHttpBodyRaw(param: userData)

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                if let data = data {
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("Response: \(jsonResponse)")
                            
                            if let isError = jsonResponse["isError"] as? Int, isError != 0,
                               let description = jsonResponse["description"] as? String,
                               let status = jsonResponse["status"] as? String {
                                
                                DispatchQueue.main.async {
                                    unwrappedVC.showAlert(title: status, message: description)
                                }
                            } else {
                                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 {
                                    DispatchQueue.main.async {
                                        unwrappedVC.showAlert(title: "Login Successful", message: "Congratulations! You have successfully Login.") {
                                            unwrappedVC.goToHome()
                                        }
                                    }
                                } else {
                                    print("Sign-Up Error: Unexpected Response Code")
                                }
                            }
                        }
                    } catch {
                        print("JSON Serialization Error: \(error)")
                    }
                }
            }
            task.resume()
        } catch {
            print("Error creating JSON data: \(error)")
        }
    }
}
