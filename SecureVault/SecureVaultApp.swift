//
//  SecureVaultApp.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/20/25.
//

import SwiftUI

@main
struct SecureVaultApp: App {
    @StateObject private var authViewModel = AuthenticationViewModel()
    @StateObject var appLockManager = AppLockManager.shared
    private let persistenceController = PersistenceController.shared // تأكد من وجود PersistenceController
    @StateObject private var categoryViewModel: CategoryViewModel

    init() {
        // تمرير managedObjectContext إلى CategoryViewModel
        let context = persistenceController.container.viewContext
        _categoryViewModel = StateObject(wrappedValue: CategoryViewModel(context: context))
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
                .environmentObject(appLockManager)
                .environmentObject(categoryViewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext) // تمرير السياق إلى البيئة
                .onAppear {
                    DataSeeder.seedPasswords(context: PersistenceController.shared.context)
                }

        }
        
    }
    
}

