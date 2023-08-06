//
//  LoginViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 05/08/23.
//

import Foundation

class LoginViewModel {
    var loginViewCtr: LoginViewController?
    
    func login(username: String, password: String) {
        guard let unwrappedVC = loginViewCtr else { return }
        
        let urlString = "https://fakestoreapi.com/users"
        guard let url = URL(string: urlString) else {
            print("URL not valid")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("Error retrieving data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let users = try JSONDecoder().decode(User.self, from: data)
                // Lakukan pengecekan login berdasarkan username dan password
                if let user = users.first(where: { $0.username == username && $0.password == password }) {
                    // Login berhasil, lakukan tindakan yang diperlukan setelah login
                    DispatchQueue.main.async {
                        unwrappedVC.loginSuccessful(user: user)
                    }
                } else {
                    // Login gagal, tampilkan pesan error
                    DispatchQueue.main.async {
                        unwrappedVC.showLoginError()
                    }
                }
                
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
