import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "SecureVault") // تأكد من تطابق الاسم مع xcdatamodeld
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return container.viewContext
    }

    // إضافة كلمة مرور جديدة
    func addPassword(serviceName: String, username: String, password: String, category: String) {
        let newPassword = PasswordEntity(context: context)
        newPassword.id = UUID()
        newPassword.serviceName = serviceName
        newPassword.username = username
        newPassword.password = EncryptionManager.shared.encrypt(text: password) ?? Data()
        newPassword.createdAt = Date()
        newPassword.category = category
        newPassword.isFavorite = false // القيمة الابتدائية

        saveContext()
    }
    func toggleFavorite(for id: UUID) {
        let request: NSFetchRequest<PasswordEntity> = PasswordEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            if let password = try context.fetch(request).first {
                password.isFavorite.toggle()
                saveContext()
            }
        } catch {
            print("❌ Failed to toggle favorite: \(error)")
        }
    }

    func updatePassword(id: UUID, serviceName: String, username: String, password: String, category: String) {
        print("✏️ Updating password with ID: \(id)")
        let request: NSFetchRequest<PasswordEntity> = PasswordEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let results = try context.fetch(request)
            print("🔍 Found \(results.count) matching password(s)")
            if let passwordToUpdate = results.first {
                passwordToUpdate.serviceName = serviceName
                passwordToUpdate.username = username
                passwordToUpdate.password = EncryptionManager.shared.encrypt(text: password) ?? Data()
                passwordToUpdate.category = category
                saveContext()
                print("✅ Updated service name to \(serviceName), category: \(category)")
            }
        } catch {
            print("❌ Failed to update password: \(error)")
        }
    }

    // جلب جميع كلمات المرور
    func fetchPasswords() -> [Password] {
        let request: NSFetchRequest<PasswordEntity> = PasswordEntity.fetchRequest()
          do {
            let results = try context.fetch(request)
            for entity in results {
                print("🔐 Encrypted Password: \(entity.password?.base64EncodedString() ?? "No Data")")
            }
            return results.map { entity in
                Password(
                        id: entity.id ?? UUID(),
                        serviceName: entity.serviceName ?? "",
                        username: entity.username ?? "",
                        encryptedPassword: entity.password ?? Data(),
                        createdAt: entity.createdAt ?? Date(),
                        category: entity.category ?? "Uncategorized",
                        isFavorite: entity.isFavorite
                    )
            }
        } catch {
            print("Failed to fetch passwords: \(error)")
            return []
        }
    }


    // حذف كلمة مرور
    func deletePassword(id: UUID) {
        let request: NSFetchRequest<PasswordEntity> = PasswordEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let results = try context.fetch(request)
            if let passwordToDelete = results.first {
                context.delete(passwordToDelete)
                saveContext()
            }
        } catch {
            print("Failed to delete password: \(error)")
        }
    }

    // حفظ التغييرات
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save Core Data changes: \(error)")
        }
    }
}
