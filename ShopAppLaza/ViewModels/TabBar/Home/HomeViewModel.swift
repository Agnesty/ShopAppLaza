//
//  HomeViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 22/08/23.
//

import Foundation

class HomeViewModel {
    
    weak var delegateSearch: searchProductHomeProtocol?
    var searchTextActive: Bool = false
    
    func getSeacrhByName(key: String, completion: @escaping (SearchProduct) -> Void) {
        guard let url = URL(string: "https://lazaapp.shop/products?search=\(key)") else { print("Invalid URL.")
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
                let searchProducts = try JSONDecoder().decode(SearchProduct.self, from: data)
                DispatchQueue.main.async {
                    completion(searchProducts)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                
            }
        }.resume()
    }
    
    func performSearch(with searchText: String) {
        if searchText.isEmpty {
            searchTextActive = false
        } else {
            searchTextActive = true
        }
        delegateSearch?.searchProdFetch(isActive: searchTextActive, textString: searchText)
    }
}
