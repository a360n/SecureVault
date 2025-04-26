//
//  TermsAndConditionsView.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/23/25.
//

import SwiftUI

struct TermsAndConditionsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                InfoCardView(
                    icon: "doc.plaintext",
                    title: "Terms & Conditions",
                    content: """
By using SecureVault, you agree to the following terms:

1. You are solely responsible for managing and securing your data.
2. The app does not collect or transmit any user data without consent.
3. Breach checking is optional and uses public APIs (HIBP).
4. The developer is not liable for data loss due to misuse.
"""
                )
            }
            .padding()
        }
        .navigationTitle("Terms & Conditions")
    }
}

#Preview {
    TermsAndConditionsView()
}

