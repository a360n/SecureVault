//
//  RootView.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/25/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appLockManager: AppLockManager

    var body: some View {
        Group {
            if appLockManager.isLocked {
                LoginView() // شاشة تسجيل الدخول (Face ID / Password)
            } else {
                PasswordListView() // التطبيق مفتوح
            }
        }
        .animation(.easeInOut, value: appLockManager.isLocked) // ✅ يعطي انتقال سلس
        .onAppear {
                    print("🟢 RootView: isLocked = \(appLockManager.isLocked)")
                }
    }
}

#Preview {
    RootView()
        .environmentObject(AppLockManager.shared)
}
