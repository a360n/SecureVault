//
//  EncryptionManager.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/20/25.
//

import Foundation
import CryptoKit

class EncryptionManager {
    static let shared = EncryptionManager()
    
    private let keyAlias = "secureVaultEncryptionKey"
    private var key: SymmetricKey
    
    private init() {
        if let savedKey = KeychainManager.shared.loadKey(forKey: keyAlias) {
            self.key = savedKey
        } else {
            let newKey = SymmetricKey(size: .bits256)
            KeychainManager.shared.saveKey(newKey, forKey: keyAlias)
            self.key = newKey
        }
    }
    
    func encrypt(text: String) -> Data? {
        guard let data = text.data(using: .utf8) else { return nil }
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            return sealedBox.combined
        } catch {
            print("Encryption failed: \(error)")
            return nil
        }
    }
    
    func decrypt(data: Data) -> String? {
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: data)
            let decryptedData = try AES.GCM.open(sealedBox, using: key)
            return String(data: decryptedData, encoding: .utf8)
        } catch {
            print("Decryption failed: \(error)")
            return nil
        }
    }
}
