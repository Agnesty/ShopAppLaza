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
    case password = "password"
    case saveProfile = "data-profile"
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
    func addTokenToKeychain(token: String, service: String) {
        let data = Data(token.utf8)
        let addquery = [
            kSecAttrService: service,
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecValueData: data
        ] as [CFString : Any] as CFDictionary
        // Add to keychain
        let status = SecItemAdd(addquery, nil)
        if status == errSecDuplicateItem {
            // Item already exists, thus update it
            let updatequery = [
                kSecAttrService: service,
                kSecAttrAccount: "laza-account",
                kSecClass: kSecClassGenericPassword
            ] as [CFString : Any] as CFDictionary
            let attributeToUpdate = [kSecValueData: data] as CFDictionary
            // Update to keychain
            let updateStatus = SecItemUpdate(updatequery, attributeToUpdate)
            if updateStatus != errSecSuccess {
                print("Error updating token to keychain, status: \(status)")
            }
        } else if status != errSecSuccess {
            print("Error adding token to keychain, status: \(status)")
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
    
    func deleteToken() {
        let spec : CFDictionary = [kSecClass: kSecClassGenericPassword] as CFDictionary
        SecItemDelete(spec)
    }
    
    func addProfileToKeychain(profile: UserElement, service: String) {
        guard let data = try? JSONEncoder().encode(profile) else {
            print("Encode error")
            return
        }
        let addquery = [
            kSecAttrService: service,
            kSecAttrAccount: "laza-account",
            kSecClass: kSecClassGenericPassword,
            kSecValueData: data
        ] as [CFString : Any] as CFDictionary
        // Add to keychain
        let status = SecItemAdd(addquery, nil)
        if status == errSecDuplicateItem {
            // Item already exists, thus update it
            let updatequery = [
                kSecAttrService: service,
                kSecAttrAccount: "laza-account",
                kSecClass: kSecClassGenericPassword
            ] as [CFString : Any] as CFDictionary
            let attributeToUpdate = [kSecValueData: data] as CFDictionary
            // Update to keychain
            let updateStatus = SecItemUpdate(updatequery, attributeToUpdate)
            if updateStatus != errSecSuccess {
                print("Error updating token to keychain, status: \(status)")
            }
        } else if status != errSecSuccess {
            print("Error adding token to keychain, status: \(status)")
        }
    }
    
    func getProfileToKeychain(service: String) -> UserElement? {
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
        if let data = ref as? Data {
            do {
                // Mendecode data yang diambil menjadi objek UserElement
                let userProfile = try JSONDecoder().decode(UserElement.self, from: data)
                return userProfile
            } catch {
                print("Gagal mendecode data dari Keychain: \(error)")
            }
        }
        return nil
    }
}
