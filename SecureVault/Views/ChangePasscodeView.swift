//
//  ChangePasscodeView.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/23/25.
//

import SwiftUI

struct ChangePasscodeView: View {
    @EnvironmentObject var appLockManager: AppLockManager
    @Environment(\.dismiss) var dismiss

    @State private var currentPasscode = ""
    @State private var newPasscode = ""
    @State private var confirmNewPasscode = ""

    @State private var errorMessage = ""
    @State private var successMessage = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Group {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Current Passcode")
                            .font(.headline)
                            .foregroundColor(.secondary)

                        SecureField("Enter current passcode", text: $currentPasscode)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("New Passcode")
                            .font(.headline)
                            .foregroundColor(.secondary)

                        SecureField("Enter new passcode", text: $newPasscode)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))

                        SecureField("Confirm new passcode", text: $confirmNewPasscode)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                    }
                }
                .padding(.horizontal)

                // Error or success messages
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.top, 5)
                }

                if !successMessage.isEmpty {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .font(.subheadline)
                        .padding(.top, 5)
                }

                Spacer()

                // Change button
                Button(action: {
                    changePasscode()
                }) {
                    Text("Change Passcode")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                }

                Spacer(minLength: 20)
            }
            .padding(.top)
            .navigationTitle("Change Passcode")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func changePasscode() {
        guard appLockManager.verifyPasscode(currentPasscode) else {
            errorMessage = "Current passcode is incorrect"
            successMessage = ""
            return
        }

        guard !newPasscode.isEmpty, newPasscode == confirmNewPasscode else {
            errorMessage = "New passcodes do not match"
            successMessage = ""
            return
        }

        appLockManager.updatePasscode(to: newPasscode)
        errorMessage = ""
        successMessage = "Passcode changed successfully"

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
}

#Preview {
    ChangePasscodeView()
}
