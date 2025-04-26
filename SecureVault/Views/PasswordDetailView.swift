//
//  PasswordDetailView.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/20/25.
//

import SwiftUI

struct PasswordDetailView: View {
    let password: Password
    @State private var showPassword = false
    @EnvironmentObject var appLockManager: AppLockManager
    @State private var isEditing = false
    @ObservedObject var viewModel: PasswordListViewModel
    func exportPassword() {
        let fileName = "\(password.serviceName)-password.txt"
        
        let decrypted = password.decryptedPassword() ?? "Failed to decrypt"

        let fileContent = """
        Service: \(password.serviceName)
        Username: \(password.username)
        Password: \(decrypted)
        Encrypted Password: \(password.encryptedPassword.base64EncodedString())
        Created At: \(password.createdAt.formatted())
        """

        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        do {
            try fileContent.write(to: url, atomically: true, encoding: .utf8)
            let av = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = scene.windows.first?.rootViewController {
                rootVC.present(av, animated: true)
            }
        } catch {
            print("Failed to export password: \(error)")
        }
    }



    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Service Name
                SectionBox(title: "Service") {
                    LabeledTextRow(icon: "globe", text: password.serviceName)
                }

                // Username
                SectionBox(title: "Username") {
                    LabeledTextRow(icon: "person", text: password.username)
                }

                // Category
                SectionBox(title: "Category") {
                    HStack {
                        Image(systemName: CategoryStyle.icon(for: password.category))
                            .foregroundColor(CategoryStyle.color(for: password.category))
                        Text(password.category)
                        Spacer()
                    }
                }

                // Password
                SectionBox(title: "Password") {
                    HStack {
                        if showPassword {
                            Text(password.decryptedPassword() ?? "Error decrypting password")
                                .font(.body.monospaced())
                        } else {
                            SecureField("Hidden", text: .constant("••••••••"))
                                .disabled(true)
                        }
                        Spacer()
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        }
                    }
                }

                // Strength
                SectionBox(title: "Strength") {
                    Text(PasswordStrengthChecker.evaluate(password.decryptedPassword() ?? "").rawValue)
                        .foregroundColor(.gray)
                }

                // Favorite toggle
                SectionBox(title: "Actions") {
                    LabeledButton(
                        icon: password.isFavorite ? "star.slash" : "star",
                        label: password.isFavorite ? "Remove from Favorites" : "Add to Favorites"
                    ) {
                        viewModel.toggleFavorite(for: password.id)
                    }

                    LabeledButton(icon: "square.and.arrow.up", label: "Export Password") {
                        exportPassword()
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarItems(trailing:
            Button("Edit") {
                isEditing = true
            }
        )
        .sheet(isPresented: $isEditing, onDismiss: {
            viewModel.refreshPasswords()
        }) {
            EditPasswordView(password: password, isPresented: $isEditing, viewModel: viewModel)
        }
    }
}


#Preview {
    PasswordDetailView(
        password: Password(
            id: UUID(),
            serviceName: "Test Service",
            username: "test@example.com",
            encryptedPassword: Data(),
            createdAt: Date(),
            category: "",
            isFavorite: false
            
        ),
        viewModel: PasswordListViewModel()
    )
}

