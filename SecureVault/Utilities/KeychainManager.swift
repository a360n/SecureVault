//
//  KeychainManager.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/20/25.
//

import Foundation
import CryptoKit

class KeychainManager {
    static let shared = KeychainManager()
    
    func saveKey(_ key: SymmetricKey, forKey keyName: String) {
        let tag = keyName.data(using: .utf8)!
        let keyData = key.withUnsafeBytes { Data(Array($0)) }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecValueData as String: keyData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func loadKey(forKey keyName: String) -> SymmetricKey? {
        let tag = keyName.data(using: .utf8)!
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess, let data = item as? Data else {
            return nil
        }
        
        return SymmetricKey(data: data)
    }
}
