//
//  SignUpViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 05/08/23.
//
import Foundation

class SignUpViewModel {
    var loading: (() -> Void)?
    var presentAlert: ((String, String) -> Void)?
    
    func registerUser(fullname: String, username: String, email: String, password: String, isMockApi: Bool) {
        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
        let register = EndpointPath.Register.rawValue
        let urlString = "\(baseUrl)\(register)"
        
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
        request.httpMethod = HttpMethod.POST.rawValue
        request.httpBody = APIService.getHttpBodyRaw(param: userData)
        
        //Permintaan ke server sesuai request-----------------Respon dari permintaan jaringan
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
                                self?.presentAlert?(status, description)
                            }
                        } else {
                            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 201 {
                                DispatchQueue.main.async { [weak self] in
                                    self?.loading?()
                                    self?.presentAlert?("Sign-Up Successful", "Please verify your email first")
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
