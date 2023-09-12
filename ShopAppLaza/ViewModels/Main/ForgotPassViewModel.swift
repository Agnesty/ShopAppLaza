//
//  ForgotPassViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 15/08/23.
//

import Foundation

class ForgotPassViewModel {
    var loading: (() -> Void)?
    var navigateToVerificationCode: (() -> Void)?
    var presentAlert: ((String, String, (() -> Void)?) -> Void)?
    
    func forgotPassSendAPICode(email: String, isMockApi: Bool) {
        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
        let forgotPass = EndpointPath.AuthForgotPassword.rawValue
        let urlString = "\(baseUrl)\(forgotPass)"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let userData: [String: Any] = [
            "email": email,
        ]

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.POST.rawValue
        request.httpBody = APIService.getHttpBodyRaw(param: userData)

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
                                
                                DispatchQueue.main.async { [weak self] in
                                    self?.loading?()
                                    self?.presentAlert?(status, description.capitalized, nil)
                                }
                            } else {
                                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 {
                                    DispatchQueue.main.async { [weak self] in
                                        self?.loading?()
                                        self?.presentAlert?("Email Sent", "Please check your email", {
                                            self?.navigateToVerificationCode?()
                                        })
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
    }
    
   
}
