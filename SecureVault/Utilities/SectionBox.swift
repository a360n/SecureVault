//
//  SectionBox.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/24/25.
//

import Foundation
import SwiftUI

struct SectionBox<Content: View>: View {
    var title: String
    var content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.bold())
                .padding(.leading, 4)

            VStack(spacing: 12) {
                content
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}
