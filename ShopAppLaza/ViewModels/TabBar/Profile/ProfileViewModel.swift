//
//  ProfileViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 20/08/23.
//

import Foundation

class ProfilViewModel {
    
    func getUserProfile(accessTokenKey: String, completion: @escaping (UserElement) -> Void) {
        let urlString = "https://lazaapp.shop/user/profile"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
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
                //let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                //print(result)
                let userprofile = try JSONDecoder().decode(UserElement.self, from: data)
                //                print("ini hasil dari data userprofile: \(userprofile)")
                DispatchQueue.main.async {
                    completion(userprofile)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}
