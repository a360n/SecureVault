//
//  LabeledButton.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/24/25.
//

import Foundation
import SwiftUI

struct LabeledButton: View {
    var icon: String
    var label: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(label)
                    .foregroundColor(.blue)
                Spacer()
            }
        }
    }
}
