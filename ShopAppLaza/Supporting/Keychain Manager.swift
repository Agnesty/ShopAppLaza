//
//  Keychain Manager.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 18/08/23.
//

import Foundation
import Security

enum Token: String {
    case access = "access-token"
    case refresh = "refresh-token"
}

class KeychainManager {
    static let keychain = KeychainManager()
    
    func saveToken(token: String, service: String) {
        let data = Data(token.utf8)
        let queary = [
            kSecAttrService: service,
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecValueData: data
        ] as [CFString : Any]
        let status = SecItemAdd(queary as CFDictionary, nil)
        
        let quearyUpdate = [
            kSecAttrService: service,
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
        ] as [CFString : Any]
        let updateStatus = SecItemUpdate(quearyUpdate as CFDictionary, [kSecValueData: data] as CFDictionary)
        if updateStatus == errSecSuccess {
            print("Update, \(status)")
        }
        else if status == errSecSuccess {
            print("User saved successfully in the keychain")
        } else {
            print("Something went wrong trying to save the user in the keychain")
        }
        
    }
    
    func getToken(service: String) -> String? {
        let queary = [
            kSecAttrService: service,
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString : Any]
        
        var ref: CFTypeRef?
        let status = SecItemCopyMatching(queary as CFDictionary, &ref)
        if status == errSecSuccess{
            print("berhasil keychain profile")
        } else {
            print("gagal, status: \(status)")
            return nil
        }
        let data = ref as! Data
        return String(decoding: data, as: UTF8.self)
    }
    
    func deleteToken(service: String) {
        let queary = [
            kSecAttrService: service,
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecValueData: true
        ] as [CFString : Any]
        
        if SecItemDelete(queary as CFDictionary) == errSecSuccess {
            print("Deleted from keychain")
        } else {
            print("Delete from keychain failed")
        }
    }
}
