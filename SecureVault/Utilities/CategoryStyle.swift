//
//  CategoryStyle.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/22/25.
//

import Foundation
import SwiftUI

struct CategoryStyle {
    static func icon(for category: String) -> String {
        switch category {
        case "Work": return "briefcase.fill"
        case "Personal": return "person.fill"
        case "Social": return "message.fill"
        case "Banking": return "creditcard.fill"
        default:
            let context = PersistenceController.shared.context // Retrieve the shared context
            let customCategory = CategoryViewModel(context: context).categories.first(where: { $0.name == category })
            return customCategory?.icon ?? "tag.fill"
        }
    }

    static func color(for category: String) -> Color {
        let rainbowColors: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple, .pink]

        switch category {
        case "Work": return .blue
        case "Personal": return .green
        case "Social": return .orange
        case "Banking": return .purple
        default:
            let index = abs(category.hashValue) % rainbowColors.count
            return rainbowColors[index]


        }
    }
}
