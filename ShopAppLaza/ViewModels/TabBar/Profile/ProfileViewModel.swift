//
//  ProfileViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 20/08/23.
//

import Foundation

class ProfilViewModel {
    var afterSaveToLocal: (() -> Void)?
    
    func getUserProfile(isMockApi: Bool, accessTokenKey: String, completion: @escaping (UserElement) -> Void) {
        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
        let userProfile = EndpointPath.UserProfile.rawValue
        let urlString = "\(baseUrl)\(userProfile)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.GET.rawValue
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
                DispatchQueue.main.async { [weak self] in
                    completion(userprofile)
                    self?.afterSaveToLocal?()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
   
}
