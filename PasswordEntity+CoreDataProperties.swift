//
//  PasswordEntity+CoreDataProperties.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/21/25.
//
//

import Foundation
import CoreData


extension PasswordEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PasswordEntity> {
        return NSFetchRequest<PasswordEntity>(entityName: "PasswordEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var serviceName: String?
    @NSManaged public var username: String?
    @NSManaged public var password: Data?
    @NSManaged public var createdAt: Date?
    @NSManaged public var category: String?
    @NSManaged public var isFavorite: Bool

}

extension PasswordEntity : Identifiable {

}
