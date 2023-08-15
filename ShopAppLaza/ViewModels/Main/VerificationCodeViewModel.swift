//
//  VerificationCodeViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 15/08/23.
//

import Foundation

class VerficationCodeViewModel {
    var verificationCodeViewCtr: VerificationCodeViewController?
    
    func verificationCode(email: String, tf1: String, tf2: String, tf3: String, tf4: String) {
        guard let unwrappedVC = verificationCodeViewCtr else { return }
        let urlString = "https://lazaapp.shop/auth/recover/code"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let combinedText = "\(tf1)\(tf2)\(tf3)\(tf4)"

        let userData: [String: Any] = [
            "email": email,
            "code": combinedText,
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
                                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 202 {
                                    DispatchQueue.main.async {
                                        unwrappedVC.showAlert(title: "Verification Code Successful", message: "Congratulations! You have successfully Verification.") {
                                            unwrappedVC.goToNewPassword(emailHttp: email, codeHttp: combinedText)
                                        }
                                    }
                                } else {
                                    print("Verification Code Error: Unexpected Response Code")
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
