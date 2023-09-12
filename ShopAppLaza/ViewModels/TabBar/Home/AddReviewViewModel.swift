//
//  AddReviewViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 19/08/23.
//

import Foundation

class AddReviewViewModel {
    var loading: (() -> Void)?
    var navigateToReview: (() -> Void)?
    var presentAlert: ((String, String, (() -> Void)?) -> Void)?
    
    func AddReview(isMockApi: Bool, id: Int, accessTokenKey: String,comment: String, rating: Double) {
        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
        let products = EndpointPath.Products.rawValue
        let urlString = "\(baseUrl)\(products)/\(id)/reviews"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let userAddReviewData: [String: Any] = [
            "comment": comment,
            "rating": rating,
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.POST.rawValue
        request.httpBody = APIService.getHttpBodyRaw(param: userAddReviewData)
        request.addValue("Bearer \(accessTokenKey)", forHTTPHeaderField: "X-Auth-Token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
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
                                self?.presentAlert?(status, description, nil)
                            }
                        } else {
                            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 201 {
                                DispatchQueue.main.async { [weak self] in
                                    self?.loading?()
                                    self?.presentAlert?("Added Review", "Your review is added.", {
                                        self?.navigateToReview?()
                                    })
                                    print("BerhasilResponse: \(jsonResponse)")
                                }
                            } else {
                                print("Add Review Error: Unexpected Response Code")
                            }
                        }
                    }
                } catch {
                    print("JSON Serialization Error: \(error)")
                }
            }
        }.resume()
    }
}
