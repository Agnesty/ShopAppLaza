//
//  AddressViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 23/08/23.
//

import Foundation

class AddressViewModel {
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
}
