//
//  ContentViewWrapper.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/21/25.
//

import Foundation
import SwiftUI

struct ContentViewWrapper: View {
    @EnvironmentObject var appLockManager: AppLockManager

    var body: some View {
        Group {
            if appLockManager.isLocked {
                LoginView()
            } else {
                PasswordListView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            appLockManager.lock()
        }
    }
}
