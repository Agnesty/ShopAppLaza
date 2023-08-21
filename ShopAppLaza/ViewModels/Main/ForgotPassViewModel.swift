//
//  ForgotPassViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 15/08/23.
//

import Foundation

class ForgotPassViewModel {
    var forgotPassViewCtr: ForgotPasswordViewController?
    var loading: (() -> Void)?
    
    func forgotPassSendAPICode(email: String) {
        guard let unwrappedVC = forgotPassViewCtr else { return }
        let urlString = "https://lazaapp.shop/auth/forgotpassword"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let userData: [String: Any] = [
            "email": email,
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
                                    unwrappedVC.showAlert(title: status, message: description.capitalized)
                                }
                            } else {
                                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 {
                                    DispatchQueue.main.async {
                                        self.loading?()
                                        unwrappedVC.showAlert(title: "Email Sent", message: "Please check your email") {
                                            unwrappedVC.goToVerificationCode(email: email)
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
