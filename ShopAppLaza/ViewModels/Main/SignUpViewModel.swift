//
//  SignUpViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 05/08/23.
//
import Foundation

class SignUpViewModel {
    var signUpViewCtr: SignUpViewController?
    var loading: (() -> Void)?
    
    func registerUser(fullname: String, username: String, email: String, password: String) {
        guard let unwrappedVC = signUpViewCtr else { return }
        let urlString = "https://lazaapp.shop/register"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let userData: [String: Any] = [
            "full_name": fullname,
            "username": fullname,
            "email": email,
            "password": password,
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = APIService.getHttpBodyRaw(param: userData)

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
                                    self.loading?()
                                    unwrappedVC.showAlert(title: status, message: description)
                                }
                            } else {
                                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 201 {
                                    DispatchQueue.main.async {
                                        self.loading?()
                                        unwrappedVC.showAlert(title: "Sign-Up Successful", message: "Please verify your email first") {
                                            unwrappedVC.goToLogin()
                                        }
                                        print("BerhasilResponse: \(jsonResponse)")
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
