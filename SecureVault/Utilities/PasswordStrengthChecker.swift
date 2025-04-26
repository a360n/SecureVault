//
//  PasswordStrengthChecker.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/21/25.
//

import Foundation

enum PasswordStrength: String {
    case veryWeak = "Very Weak"
    case weak = "Weak"
    case moderate = "Moderate"
    case strong = "Strong"
    
    var color: String {
        switch self {
        case .veryWeak: return "red"
        case .weak: return "orange"
        case .moderate: return "yellow"
        case .strong: return "green"
        }
    }
}

struct PasswordStrengthChecker {
    static func evaluate(_ password: String) -> PasswordStrength {
        let length = password.count
        let hasUpper = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasLower = password.range(of: "[a-z]", options: .regularExpression) != nil
        let hasDigit = password.range(of: "[0-9]", options: .regularExpression) != nil
        let hasSymbol = password.range(of: "[^A-Za-z0-9]", options: .regularExpression) != nil

        var score = 0
        if length >= 8 { score += 1 }
        if hasUpper { score += 1 }
        if hasLower { score += 1 }
        if hasDigit { score += 1 }
        if hasSymbol { score += 1 }

        switch score {
        case 0...1: return .veryWeak
        case 2: return .weak
        case 3: return .moderate
        default: return .strong
        }
    }
}

