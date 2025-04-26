//
//  PasswordListViewModel.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/20/25.
//

import Foundation
import Combine

class PasswordListViewModel: ObservableObject {
    @Published var passwords: [Password] = []
    @Published var selectedDefaultCategory: String? = nil
    
    @Published var searchText: String = "" {
        didSet {
            filterPasswords()
        }
    }
    @Published var filteredPasswords: [Password] = []
    
    @Published var selectedCategory: String = "All" {
        didSet {
            filterPasswords()
        }
    }
    
    @Published var showFavoritesOnly: Bool = false {
        didSet {
            filterPasswords()
        }
    }


    var allCategories: [String] {
        let custom = CategoryViewModel(context: PersistenceController.shared.context).categories.map { $0.name ?? "Unnamed" }
        return ["All"] + custom
    }

    init() {
        fetchPasswords()
    }

    func fetchPasswords() {
        passwords = CoreDataManager.shared.fetchPasswords()
        filterPasswords()
    }

    func refreshPasswords() {
        fetchPasswords()
    }

    private func filterPasswords() {
        filteredPasswords = passwords.filter { password in
            (selectedCategory == "All" || selectedCategory.isEmpty || password.category == selectedCategory)
            &&
            (!showFavoritesOnly || password.isFavorite)
            &&
            (searchText.isEmpty ||
             password.serviceName.localizedCaseInsensitiveContains(searchText) ||
             password.username.localizedCaseInsensitiveContains(searchText))
        }
    }


    func addPassword(serviceName: String, username: String, password: String, category: String) {
        CoreDataManager.shared.addPassword(serviceName: serviceName, username: username, password: password, category: category)
        print("Adding password to Core Data for \(serviceName)")
        refreshPasswords()
    }

    func toggleFavorite(for id: UUID) {
        CoreDataManager.shared.toggleFavorite(for: id)
        fetchPasswords()
    }

    func deletePassword(at offsets: IndexSet) {
        for index in offsets {
            let password = filteredPasswords[index]
            CoreDataManager.shared.deletePassword(id: password.id)
        }
        fetchPasswords()
    }
}

