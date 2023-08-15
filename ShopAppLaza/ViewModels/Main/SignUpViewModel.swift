//
//  SignUpViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 05/08/23.
//

import Foundation
import CryptoKit

class SignUpViewModel {
    var signUpViewCtr: SignUpViewController?
    
    static func getHttpBodyRaw(param: [String:Any]) -> Data? {
        let jsonData = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        return jsonData
    }
    
    func registerUser() {
        guard let unwrappedVC = signUpViewCtr else { return }
        let urlString = "https://lazaapp.shop/register"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let userData: [String: Any] = [
            "full_name": unwrappedVC.usernameTF.text ?? "",
            "username": unwrappedVC.usernameTF.text ?? "",
            "email": unwrappedVC.emailTF.text ?? "",
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
                                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 201 {
                                    DispatchQueue.main.async {
                                        unwrappedVC.showAlert(title: "Sign-Up Successful", message: "Please verify your email first") {
                                            unwrappedVC.goToLogin()
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
