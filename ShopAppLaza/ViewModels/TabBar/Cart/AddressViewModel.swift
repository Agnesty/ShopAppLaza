//
//  AddressViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 23/08/23.
//

import Foundation

class AddressViewModel {
    var detailViewCtr: AddressViewController?
    var loading: (() -> Void)?
    
    func getAllAddress(accessTokenKey: String, completion: @escaping (AllAddress) -> Void) {
        guard let url = URL(string: "https://lazaapp.shop/address") else {
            print("Invalid URL.")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
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
                let getAllAddress = try JSONDecoder().decode(AllAddress.self, from: data)
                
                DispatchQueue.main.async {
                    completion(getAllAddress)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    func deleteAddressById(id: Int, accessTokenKey: String, completion: @escaping (Bool) -> Void) {
        guard let unwrappedVC = detailViewCtr else { return }
        guard let url = URL(string: "https://lazaapp.shop/address/\(id)") else {
            print("Invalid URL.")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
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
                    if let data = jsonResponse["data"] as? String,
                       let status = jsonResponse["status"] as? String{
                        DispatchQueue.main.async {
                            self.loading?()
                            unwrappedVC.showAlert(title: "Cart Updated", message: data) {
                                completion(status == "OK")
                                print("Status Check:", status)
                                print("Berhasil Response Please:", jsonResponse)
                            }
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
