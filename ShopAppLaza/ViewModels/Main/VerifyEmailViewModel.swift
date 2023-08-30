//
//  VerifyEmailViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 28/08/23.
//

import Foundation

class verifyEmailViewModel {
    var loading: (() -> Void)?
    var presentAlert: ((String, String, (() -> Void)?) -> Void)?
    
    func verifyEmailUser(email: String, isMockApi: Bool) {
        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
        let emailVerify = EndpointPath.AuthResendVerify.rawValue
        let urlString = "\(baseUrl)\(emailVerify)"
        
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
                                
                                DispatchQueue.main.async { [weak self] in
                                    self?.loading?()
                                    self?.presentAlert?(status, description, nil)
                                }
                            } else {
                                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 {
                                    DispatchQueue.main.async { [weak self] in
                                        self?.loading?()
                                        if let data = jsonResponse["data"] as? [String: Any],
                                           let message = data["message"] as? String {
                                            self?.presentAlert?("Resend Email", message, nil)
                                        }
                                        print("BerhasilResponse: \(jsonResponse)")
                                    }
                                } else {
                                    print("VerifyEmail Error: Unexpected Response Code")
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
