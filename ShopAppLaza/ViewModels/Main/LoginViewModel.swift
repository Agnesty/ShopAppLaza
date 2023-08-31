//
//  LoginViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 05/08/23.
//

import Foundation

class LoginViewModel {
    var loading: (() -> Void)?
    var navigateToHome: (() -> Void)?
    var navigateToVerifyEmail: (() -> Void)?
    var presentAlert: ((String, String, (() -> Void)?) -> Void)?
    
    func loginUser(username: String, password: String, isMockApi: Bool) {
        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
        let login = EndpointPath.Login.rawValue
        let urlString = "\(baseUrl)\(login)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let userData: [String: Any] = [
            "username": username,
            "password": password,
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
                                if description == "please verify your account" {
                                    DispatchQueue.main.async { [weak self] in
                                        self?.loading?()
                                        self?.presentAlert?(status, description, {
                                            self?.navigateToVerifyEmail?()
                                        })
                                    }
                                } else if description == "username or password is invalid" {
                                    DispatchQueue.main.async { [weak self] in
                                        self?.loading?()
                                        self?.presentAlert?(status, description, nil)
                                    }
                                }
                            } else {
                                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 {
                                    DispatchQueue.main.async { [weak self] in
                                        self?.loading?()
                                        self?.presentAlert?("Login Successful", "Congratulations! You have successfully Login.", {
                                            if let data = jsonResponse["data"] as? [String: Any],
                                               let accessToken = data["access_token"] as? String,
                                            let refreshToken = data["refresh_token"] as? String {
                                                UserDefaults.standard.set(accessToken, forKey: "accessToken")
                                                UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                                                self?.navigateToHome?()
                                            }
                                        })
                                        
                                        print("BerhasilResponse: \(jsonResponse)")
                                    }
                                } else {
                                    print("Login Error: Unexpected Response Code")
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
