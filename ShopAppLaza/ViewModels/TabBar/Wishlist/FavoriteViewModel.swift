//
//  FavoriteViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 21/08/23.
//

import Foundation

class FavoriteViewModel{
    var favoriteViewCtr: FavoriteViewController?
    func getFavoriteList(accessTokenKey: String, completion: @escaping (Wishlist) -> Void) {
        guard let url = URL(string: "https://lazaapp.shop/wishlists") else {
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
                let detailWishlist = try JSONDecoder().decode(Wishlist.self, from: data)

                DispatchQueue.main.async {
                    completion(detailWishlist)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}
