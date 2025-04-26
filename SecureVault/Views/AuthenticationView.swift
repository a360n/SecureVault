//
//  AuthenticationView.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/25/25.
//
import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("🔐 SecureVault")
                .font(.largeTitle)

            if authViewModel.isUnlocked {
                Text("✅ Unlocked Successfully!")
                    .font(.title2)
                    .foregroundColor(.green)
            } else {
                Button("Unlock with Face ID") {
                    authViewModel.unlockWithFaceID()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)

                if let error = authViewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
        }
        .padding()
        .onAppear {
            authViewModel.unlockWithFaceID()
        }
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthenticationViewModel())
}
