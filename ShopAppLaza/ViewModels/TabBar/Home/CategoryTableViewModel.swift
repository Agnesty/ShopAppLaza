//
//  ForgotPasswordViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 06/08/23.
//

import Foundation

class CategoryTableViewModel {
    var categoryTableViewCell: CategoryTableViewCell?
    
    func getDataCategories(isMockApi: Bool, completion: @escaping (Brand) -> Void) {
        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
        let brand = EndpointPath.Brands.rawValue
        let urlString = "\(baseUrl)\(brand)"
        
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
                let categories = try JSONDecoder().decode(Brand.self, from: data)
                DispatchQueue.main.async {
                    completion(categories)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}
