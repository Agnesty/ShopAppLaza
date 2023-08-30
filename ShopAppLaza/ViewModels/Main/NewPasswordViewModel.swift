//
//  NewPasswordViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 15/08/23.
//

import Foundation

class NewPasswordViewModel {
    var loading: (() -> Void)?
    var presentAlert: ((String, String, (() -> Void)?) -> Void)?
    var navigateToLogin: (() -> Void)?
    
    func newPassword(newPass: String, rePassword: String, email: String, code: String, isMockApi: Bool) {
        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
        let newPassword = EndpointPath.NewPassword.rawValue
        guard var components = URLComponents(string: "\(baseUrl)\(newPassword)") else {
            print("Invalid URL.")
            return
        }
        components.queryItems = [
            URLQueryItem(name: "email", value: "\(email)"),
            URLQueryItem(name: "code", value: "\(code)")
        ]
        guard let url = components.url else {
            print("Invalid URL components.")
            return
        }

        let userData: [String: Any] = [
            "new_password": newPass,
            "re_password": rePassword,
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
                                        self?.presentAlert?("New Password Changed", "You have successfully changed your password.", {
                                            self?.navigateToLogin?()
                                        })
                                        print("BerhasilResponse: \(jsonResponse)")
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
