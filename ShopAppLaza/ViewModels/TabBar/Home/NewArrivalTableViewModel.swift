//
//  HomeViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 05/08/23.
//

import Foundation

class NewArrivalTableViewModel {
    var newArrivalTableViewCell: NewArrivalTableViewCell?
    
    func getDataProduct(isMockApi: Bool, completion: @escaping (Welcome) -> Void) {
        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
        let products = EndpointPath.Products.rawValue
        let urlString = "\(baseUrl)\(products)"
        
        guard let url = URL(string: urlString) else { print("Invalid URL.")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                print("Data is nil.")
                return
            }
            do {
                let products = try JSONDecoder().decode(Welcome.self, from: data)

                DispatchQueue.main.async {
                    completion(products)
                }
            } catch {
                print("Error decoding JSON: \(error)")
             
            }
        }.resume()
    }
}
