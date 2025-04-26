//
//  CategoryViewModel.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/22/25.
//
import Foundation
import CoreData
import SwiftUI


class CategoryViewModel: ObservableObject {
    @Published var categories: [CategoryEntity] = []
    let managedObjectContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.managedObjectContext = context
        fetchCategories()
    }

    // ✅ قائمة افتراضية غير مرتبطة بـ Core Data
    static let defaultCategories: [(name: String, icon: String)] = [
        ("All", "tray.full.fill"),
        ("Work", "briefcase.fill"),
        ("Personal", "person.fill"),
        ("Social", "bubble.left.and.bubble.right.fill"),
        ("Banking", "banknote.fill")
    ]

    func fetchCategories() {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        do {
            categories = try managedObjectContext.fetch(request)
        } catch {
            print("❌ Failed to fetch categories: \(error.localizedDescription)")
        }
    }

    func addCategory(_ category: CategoryEntity) {
        categories.append(category)
    }

    func deleteCategory(_ category: CategoryEntity) {
        managedObjectContext.delete(category)
        do {
            try managedObjectContext.save()
            fetchCategories()
        } catch {
            print("❌ Failed to delete category: \(error.localizedDescription)")
        }
    }

    var customCategories: [CategoryEntity] {
        categories.filter { cat in
            !Self.defaultCategories.contains(where: { $0.name == cat.name })
        }
    }
}
