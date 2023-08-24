//
//  AddAddressViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 23/08/23.
//

import Foundation

class AddAddressViewModel {
    var addAddressCtr: AddAddressViewController?
    var loading: (() -> Void)?
    
    func addAddressCart(country: String, city: String, receiverName: String, phoneNumber: String, isPrimary: Bool, accessTokenKey: String) {
        
        print("apakah ini jalan addnya")
        guard let unwrappedVC = addAddressCtr else { return }
        let urlString = "https://lazaapp.shop/address"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let addressData: [String: Any] = [
            "country": country,
            "city": city,
            "receiver_name": receiverName,
            "phone_number": phoneNumber,
            "is_primary": isPrimary
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = APIService.getHttpBodyRaw(param: addressData)
        request.addValue("Bearer \(accessTokenKey)", forHTTPHeaderField: "X-Auth-Token")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: addressData, options: [])
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
                                        unwrappedVC.showAlert(title: "New Address Added", message: "You have successfully added new address.")
                                        {
                                                unwrappedVC.goBackAfterAddAddress()
                                        }
                                        print("BerhasilResponse: \(jsonResponse)")
                                    }
                                } else {
                                    print("Add Address Error: Unexpected Response Code")
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
    
    func editAddressById(id: Int, accessTokenKey: String, country: String, city: String, receiverName: String, phoneNo: String, isPrimary: Bool, completion: @escaping (Bool) -> Void) {
        print("ini editAddress Function")
        guard let unwrappedVC = addAddressCtr else { return }
        guard let url = URL(string: "https://lazaapp.shop/address/\(id)") else {
            print("Invalid URL.")
            return
        }
        
        let userAddress: [String: Any] = [
            "country": country,
            "city": city,
            "receiver_name": receiverName,
            "phone_number": phoneNo,
            "is_primary": isPrimary,
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = APIService.getHttpBodyRaw(param: userAddress)
        request.addValue("Bearer \(accessTokenKey)", forHTTPHeaderField: "X-Auth-Token")
        
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
                        DispatchQueue.main.async {
                            self.loading?()
                            unwrappedVC.showAlert(title: status, message: description)
                        } 
                    } else {
                        if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 {
                            DispatchQueue.main.async {
                                self.loading?()
                                unwrappedVC.showAlert(title: "Updated Address", message: "You have successfully update.")
                                {
                                unwrappedVC.goBackAfterAddAddress()
                                }
                                print("BerhasilResponse: \(jsonResponse)")
                            }
                        } else {
                            print("Login Error: Unexpected Response Code")
                        }
                    }
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion(false)
            }
        }.resume()
    }
    
   
}
