//
//  ForgotPassViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 15/08/23.
//

import Foundation

class ForgotPassViewModel {
    var forgotPassViewCtr: ForgotPasswordViewController?
    
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
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // Set the content type
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: userData) {
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
                            
                               if let data = jsonResponse["data"] as? [String: Any],
                               let message = data["message"] as? String {

                                   DispatchQueue.main.async {
                                       unwrappedVC.showAlert(title: "Success", message: message){
                                           unwrappedVC.goToVerificationCode(email: email)
                                       }
                                   }
                            } else {
                                print("Request Error: Unexpected Response")
                            }
                        }
                    } catch {
                        print("JSON Serialization Error: \(error)")
                    }
                }
            }
            task.resume()
        } else {
            print("Error creating JSON data")
        }
    }

    
}
