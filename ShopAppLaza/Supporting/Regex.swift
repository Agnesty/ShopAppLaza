//
//  Regex.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 03/08/23.
//

import Foundation

class Regex {
    static let shared = Regex()
    
    func invalidEmail(_ value: String) -> String? {
        if value.isEmpty {
            return "Email is required"
        }
        
        // Karakter huruf besar(A-Z), huruf kecil(a-z), angka(0-9), serta karakter khusus seperti _, ., %, +, -.
        let regularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        if !predicate.evaluate(with: value)
        {
            return "Invalid Email Address"
        }
        return nil
    }
    
    func invalidPassword(_ value: String) -> String? {
        if value.isEmpty {
            return "Min 8 characters, at least 1 letter, 1 number, and 1 special character"
        }
        
        //Minimum eight characters, at least one letter, one number, and one special character
        let regularExpression = #"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        if !predicate.evaluate(with: value)
        {
            return "Invalid Password"
        }
        return nil
    }
}
