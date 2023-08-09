//
//  CryptoKit.swift
//  ShopAppLaza
//
//  Created by Agnes Triselia Yudia on 08/08/23.
//

import CryptoKit
import UIKit

class EncryptDescrypt{
    func encryptData(_ data: Data, using key: SymmetricKey) throws -> Data {
        return try AES.GCM.seal(data, using: key).combined!
    }
    
}
