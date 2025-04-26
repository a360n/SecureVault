//
//  CategoryEntity+CoreDataProperties.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/22/25.
//
//

import Foundation
import CoreData


extension CategoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntity> {
        return NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var icon: String?

}

extension CategoryEntity : Identifiable {

}
