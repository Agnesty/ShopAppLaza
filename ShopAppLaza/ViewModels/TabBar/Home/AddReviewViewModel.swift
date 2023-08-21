//
//  AddReviewViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 19/08/23.
//

import Foundation

class AddReviewViewModel {
    var addReviewCtr: AddReviewController?
    var loading: (() -> Void)?
    
    func AddReview(id: Int, accessTokenKey: String,comment: String, rating: Double) {
        guard let unwrappedVC = addReviewCtr else { return }
        let urlString = "https://lazaapp.shop/products/\(id)/reviews"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let userAddReviewData: [String: Any] = [
            "comment": comment,
            "rating": rating,
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = APIService.getHttpBodyRaw(param: userAddReviewData)
        request.addValue("Bearer \(accessTokenKey)", forHTTPHeaderField: "X-Auth-Token")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userAddReviewData, options: [])
            request.httpBody = jsonData
            print("ini adalah jsonData: \(jsonData)")
            
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
                                        unwrappedVC.showAlert(title: "Added Review", message: "Your review is added.")
                                        {
                                            unwrappedVC.goToReview()
                                        }
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
            }
            task.resume()
        } catch {
            print("Error creating JSON data: \(error)")
        }
    }
}
