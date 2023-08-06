//
//  Screen2ViewModel.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 05/08/23.
//

import Foundation

class Screen2ViewModel {
    var screen2ViewCtr: Screen2ViewController?
    
    func isLoggedIn() -> Bool? {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
}
