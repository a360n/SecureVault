//
//  AboutAppView.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/23/25.
//

import SwiftUI

struct AboutAppView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Section: What is SecureVault
                InfoCardView(
                    icon: "lock.shield.fill",
                    title: "What is SecureVault?",
                    content: """
SecureVault is a private password manager designed by Ali Nasser. It securely stores and organizes your passwords locally using AES-256 encryption, with biometric authentication for extra safety.

Your passwords never leave your device unless you enable optional encrypted cloud sync.
"""
                )

                // Section: Encryption Details
                InfoCardView(
                    icon: "key.fill",
                    title: "How Encryption Works",
                    content: """
Every password is encrypted using AES-256 encryption before being saved to Core Data.

Your master passcode is stored securely using Apple's Keychain. Even we can't access your passwords.
"""
                )

                // Section: API Usage
                InfoCardView(
                    icon: "network.badge.shield.half.filled",
                    title: "API Usage",
                    content: """
SecureVault integrates with the HaveIBeenPwned (HIBP) API to check whether your email or password has been exposed in data breaches.

We only send partial hashes to HIBP (for passwords), or your email securely when checking. No passwords are ever sent in plain text.
"""
                )
            }
            .padding()
        }
        .navigationTitle("About SecureVault")
    }
}

struct InfoCardView: View {
    let icon: String
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.title3)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }

            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
        )
    }
}

#Preview {
    AboutAppView()
}
