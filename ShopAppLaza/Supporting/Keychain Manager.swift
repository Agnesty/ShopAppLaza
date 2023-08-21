//
//  Keychain Manager.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 18/08/23.
//

import Foundation

class KeychainManager {
    static let keychain = KeychainManager()
    
    func save(_ data: Data, service: String, account: String) {
        
        // Create query
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as [CFString : Any] as CFDictionary
        
        // Add data in query to keychain
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            // Print out the error
            print("Error: \(status)")
        }
    }
    
    
    func read(service: String, account: String) -> Data? {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString : Any] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    func delete(service: String, account: String) {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
        ] as [CFString : Any] as CFDictionary
        
        // Delete item from keychain
        SecItemDelete(query)
    }
    
    //    func update(_ data: Data, service: String, account: String) {
    //
    //        if status == errSecDuplicateItem {
    //            // Item already exist, thus update it.
    //            let query = [
    //                kSecAttrService: service,
    //                kSecAttrAccount: account,
    //                kSecClass: kSecClassGenericPassword,
    //            ] as [CFString : Any] as CFDictionary
    //
    //            let attributesToUpdate = [kSecValueData: data] as CFDictionary
    //
    //            // Update existing item
    //            SecItemUpdate(query, attributesToUpdate)
    //        }
    //    }
}
