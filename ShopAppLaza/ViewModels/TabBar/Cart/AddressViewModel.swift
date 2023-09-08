//
//  AddressViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 23/08/23.
//

import Foundation

class AddressViewModel {
    var loading: (() -> Void)?
    var presentAlert: ((String, String, (() -> Void)?) -> Void)?
    
    func getAllAddress(isMockApi: Bool, accessTokenKey: String, completion: @escaping (AllAddress) -> Void) {
        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
        let address = EndpointPath.Address.rawValue
        let urlString = "\(baseUrl)\(address)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
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
                let getAllAddress = try JSONDecoder().decode(AllAddress.self, from: data)
                
                DispatchQueue.main.async {
                    completion(getAllAddress)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    func deleteAddressById(isMockApi: Bool, id: Int, accessTokenKey: String, completion: @escaping (Bool) -> Void) {
        let baseUrl = APIService.APIAddress(isMockApi: isMockApi)
        let address = EndpointPath.Address.rawValue
        let urlString = "\(baseUrl)\(address)"
        guard let url = URL(string: "\(urlString)/\(id)") else {
            print("Invalid URL.")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.DELETE.rawValue
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
                        DispatchQueue.main.async { [weak self] in
                            self?.loading?()
                            self?.presentAlert?("Deleted Address", data, {
                                completion(status == "OK")
                                print("Status Check:", status)
                                print("Berhasil Response Please:", jsonResponse)
                            })
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
