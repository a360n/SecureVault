//
//  AuthenticationManager.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/20/25.
//

import Foundation
import LocalAuthentication

class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    func authenticateUser(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate to access Secure Vault") { success, error in
                DispatchQueue.main.async {
                    completion(success, error)
                }
            }
        } else {
            completion(false, error)
        }
    }
}
