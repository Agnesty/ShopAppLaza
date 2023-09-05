//
//  ChangePassViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 05/09/23.
//

import Foundation

class ChangePassViewModel {
    var loading: (() -> Void)?
    var navigateToBack: (() -> Void)?
    var presentAlert: ((String, String, (() -> Void)?) -> Void)?
    
    func changePass(oldPass: String, newPass: String, confirmPass: String, isMockApi: Bool, accessTokenKey: String) {
        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
        let changePass = EndpointPath.UserChangePassword.rawValue
        let urlString = "\(baseUrl)\(changePass)"
        
        guard let url = URL(string: urlString) else { print("Invalid URL.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.PUT.rawValue
        request.setValue("Bearer \(accessTokenKey)", forHTTPHeaderField: "X-Auth-Token")
        
        let parameters: [String: Any] = [
          "old_password": oldPass,
          "new_password": newPass,
          "re_password": confirmPass
        ]
        
        do {
          request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
          print("Failed to Create JSON Data")
          return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                print("Data is nil.")
                return
            }
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let isError = jsonResponse["isError"] as? Int, isError != 0,
                       let description = jsonResponse["description"] as? String,
                       let status = jsonResponse["status"] as? String {
                        DispatchQueue.main.async { [weak self] in
                            self?.loading?()
                            self?.presentAlert?(status, description, nil)
                            print("gagalResponse: \(jsonResponse)")
                        }
                    } else {
                        if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 {
                            DispatchQueue.main.async { [weak self] in
                                self?.loading?()
                                self?.presentAlert?("Updated Password", "You have successfully update.", {
                                    self?.navigateToBack?()
                                })
                                print("BerhasilResponse: \(jsonResponse)")
                            }
                        } else {
                            print("Login Error: Unexpected Response Code")
                        }
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
        }
        
    }

