//
//  LabeledNavigationLink.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/24/25.
//

import Foundation
import SwiftUI

struct LabeledNavigationLink<Destination: View>: View {
    var icon: String
    var label: String
    var destination: Destination

    init(icon: String, label: String, @ViewBuilder destination: () -> Destination) {
        self.icon = icon
        self.label = label
        self.destination = destination()
    }

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(label)
                    .foregroundColor(.blue)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
    }
}
