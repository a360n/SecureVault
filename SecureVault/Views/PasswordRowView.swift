//
//  PasswordRowView.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/22/25.
//

import SwiftUI

func isValidSystemIcon(_ icon: String?) -> Bool {
    guard let icon = icon else { return false }
    return UIImage(systemName: icon) != nil
}
func isValidSystemIcon(_ name: String) -> Bool {
    UIImage(systemName: name) != nil
}

struct PasswordRowView: View {
    let password: Password

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(CategoryStyle.color(for: password.category).opacity(0.2))
                    .frame(width: 32, height: 32)

                Image(systemName: CategoryStyle.icon(for: password.category))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(CategoryStyle.color(for: password.category)) // ✅ هنا
            }
            ZStack {
                Circle()
                    .fill(CategoryStyle.color(for: password.category).opacity(0.2))
                    .frame(width: 32, height: 32)

                Image(systemName: CategoryStyle.icon(for: password.category))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(CategoryStyle.color(for: password.category)) // ✅ هنا
            }

            VStack(alignment: .leading) {
                HStack {
                    if password.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    Text(password.serviceName)
                        .font(.headline)
                }

                Text(password.username)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 6) // optional لتحسين الشكل
    }
}

#Preview {
    PasswordRowView(password: Password(
        id: UUID(),
        serviceName: "Twitter",
        username: "ali@example.com",
        encryptedPassword: Data(),
        createdAt: Date(),
        category: "Social",
        isFavorite: true
    ))
}
