//
//  LoginView.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/20/25.
//
import SwiftUI

struct LoginView: View {
    @State private var usePasswordLogin = false
    @State private var inputPassword = ""
    @State private var showError = false

    @EnvironmentObject var appLockManager: AppLockManager

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 12) {
                Image(systemName: "lock.shield.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                    .padding(.bottom, 8)

                Text("Secure Vault")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }

            Spacer(minLength: 30)

            if usePasswordLogin {
                SecureField("Enter Password", text: $inputPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.4), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)

                Button(action: {
                    let unlocked = appLockManager.unlock(with: inputPassword)
                    print("🔓 Password unlock result: \(unlocked)")
                    withAnimation {
                        showError = !unlocked
                    }
                }) {
                    HStack {
                        Image(systemName: "key.fill")
                        Text("Unlock")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal, 24)

            } else {
                Button(action: authenticateWithFaceID) {
                    HStack {
                        Image(systemName: "faceid")
                        Text("Unlock with Face ID")
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(14)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal, 24)
            }

            if showError {
                Text("Authentication Failed")
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.top, 8)
                    .multilineTextAlignment(.center)
            }

            Button(usePasswordLogin ? "Use Face ID Instead" : "Use Password Instead") {
                withAnimation {
                    usePasswordLogin.toggle()
                    inputPassword = ""
                    showError = false
                }
            }
            .font(.footnote)
            .padding(.top, 12)

            Spacer()
        }
        .padding(.top)
        .background(Color(.systemBackground).ignoresSafeArea())
    }

    private func authenticateWithFaceID() {
        AuthenticationManager.shared.authenticateUser { success, error in
            DispatchQueue.main.async {
                if success {
                    let unlocked = appLockManager.unlock(with: appLockManager.currentPasscode)
                    print("🔓 Face ID unlock result: \(unlocked)")
                    withAnimation {
                        showError = !unlocked
                    }
                } else {
                    showError = true
                }
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AppLockManager.shared)
}


#Preview {
    LoginView()
        .environmentObject(AppLockManager.shared)
}
