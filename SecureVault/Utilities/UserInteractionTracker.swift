//
//  UserInteractionTracker.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/21/25.
//

import Foundation
import UIKit
import SwiftUI

class UserInteractionTracker {
    static func startTracking() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            addTapRecognizer()
        }
    }

    private static func addTapRecognizer() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first else {
                print("No window found for tap tracking")
                return
        }

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        tapRecognizer.cancelsTouchesInView = false
        window.addGestureRecognizer(tapRecognizer)

        print("Tap recognizer added")
    }

    @objc private static func tapDetected() {
        AppLockManager.shared.userInteracted()
        print("User interaction detected")
    }
}
