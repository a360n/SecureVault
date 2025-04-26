//
//  AuthenticationViewModel.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/20/25.
//

import SwiftUI
import Combine
import Foundation
import LocalAuthentication

class AuthenticationViewModel: ObservableObject {
    @Published var isUnlocked = false
    @Published var errorMessage: String?

    func unlockWithFaceID() {
        AuthenticationManager.shared.authenticateUser { success, error in
            DispatchQueue.main.async {
                if success {
                    self.isUnlocked = true
                    self.errorMessage = nil
                    AppLockManager.shared.isLocked = false 
                } else {
                    self.isUnlocked = false // 🧩 هذا هو السطر المهم المفقود
                    self.errorMessage = error?.localizedDescription ?? "Unknown error"
                }
            }
        }
    }

    func unlockWithPassword(_ input: String) {
        if AppLockManager.shared.unlock(with: input) {
            isUnlocked = true
            errorMessage = nil
        } else {
            errorMessage = "Incorrect master password"
        }
    }
}



