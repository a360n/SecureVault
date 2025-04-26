//
//  Password.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/20/25.
//

import Foundation
import CoreData
extension Password: Hashable {}

struct Password: Identifiable {
    var id: UUID
    var serviceName: String
    var username: String
    var encryptedPassword: Data
    var createdAt: Date
    let category: String
    let isFavorite: Bool
    
    // فك التشفير عند الحاجة
    func decryptedPassword() -> String? {
        return EncryptionManager.shared.decrypt(data: encryptedPassword)
    }
}


