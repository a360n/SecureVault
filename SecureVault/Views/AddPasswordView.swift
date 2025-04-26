//
//  AddPasswordView.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/20/25.
//

import SwiftUI

struct AddPasswordView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: PasswordListViewModel
    @EnvironmentObject var appLockManager: AppLockManager
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @State var selectedDefaultCategory: String?
    @State private var serviceName = ""
    @State private var username = ""
    @State private var password = ""
    @State private var selectedCategoryID: UUID? = nil

    @State private var navigateTo: Password? = nil
    @State private var pwnedMessage: String?
    @State private var emailBreachMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Title
                Text("Add New Password")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                // Service & Username Box
                GroupBox {
                    VStack(alignment: .leading, spacing: 20) {

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Service Name")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            TextField("Enter Service Name", text: $serviceName)
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Username or Email")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            TextField("Enter Username or Email", text: $username)
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Password")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            SecureField("Enter a strong password", text: $password)
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }

                        HStack {
                            Text("Strength:")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text(PasswordStrengthChecker.evaluate(password).rawValue)
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 6)
                    }
                    .padding()
                }
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                .padding(.vertical, 6)
               


                // Category Picker
                GroupBox(label: Label("Category", systemImage: "tag.fill")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            // ✅ الفئات الافتراضية
                            ForEach(CategoryViewModel.defaultCategories, id: \.name) { defaultCategory in
                                HStack {
                                    Image(systemName: defaultCategory.icon)
                                    Text(defaultCategory.name)
                                }
                                .padding(8)
                                .background(viewModel.selectedDefaultCategory == defaultCategory.name ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .onTapGesture {
                                    selectedCategoryID = nil
                                    viewModel.selectedDefaultCategory = defaultCategory.name
                                }
                            }

                            // ✅ الفئات المخصصة
                            ForEach(categoryViewModel.categories, id: \.self) { category in
                                HStack {
                                    Image(systemName: category.icon ?? "tag")
                                    Text(category.name ?? "")
                                }
                                .padding(8)
                                .background(selectedCategoryID == category.id ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .onTapGesture {
                                    selectedCategoryID = category.id
                                    viewModel.selectedDefaultCategory = nil // ✅ أزل الفئة الافتراضية المحددة
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                // Email Check
                Button(action: {
                    EmailBreachChecker.checkEmailBreach(username) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let breaches):
                                if breaches.isEmpty {
                                    emailBreachMessage = " Email not found in any breach."
                                } else {
                                    let first = breaches.prefix(3)
                                    let extra = breaches.count - first.count
                                    var message = "⚠️ Found in: \(first.joined(separator: ", "))"
                                    if extra > 0 {
                                        message += " and \(extra) more..."
                                    }
                                    emailBreachMessage = message
                                }
                            case .failure(let error):
                                emailBreachMessage = "❌ Error: \(error.localizedDescription)"
                            }
                        }
                    }
                }) {
                    Label("Check Email Breach", systemImage: "envelope.badge")
                }
                .foregroundColor(.orange)
                .disabled(username.isEmpty)

                if let emailMessage = emailBreachMessage {
                    breachMessageView(text: emailMessage)
                }

                // Password Breach Check
                Button(action: {
                    PwnedPasswordChecker.checkPassword(password) { isPwned, count in
                        DispatchQueue.main.async {
                            if isPwned {
                                pwnedMessage = "⚠️ This password appeared in \(count) data breaches!"
                            } else {
                                pwnedMessage = "✅ This password is safe and not found in any breaches."
                            }
                        }
                    }
                }) {
                    Label("Check Password Breach", systemImage: "lock.shield")
                }
                .foregroundColor(.blue)
                .disabled(password.isEmpty)

                if let message = pwnedMessage {
                    breachMessageView(text: message)
                }

                // Save Button
                Button("Save Password") {
                    let categoryName: String
                    if let selectedCustom = categoryViewModel.categories.first(where: { $0.id == selectedCategoryID }) {
                        categoryName = selectedCustom.name ?? "Uncategorized"
                    } else if let selectedDefault = viewModel.selectedDefaultCategory {
                        categoryName = selectedDefault
                    } else {
                        categoryName = "Uncategorized"
                    }

                    viewModel.addPassword(
                        serviceName: serviceName,
                        username: username,
                        password: password,
                        category: categoryName
                    )
                    viewModel.refreshPasswords()
                    if let last = viewModel.passwords.last {
                        navigateTo = last
                        clearFields()
                        isPresented = false
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .disabled(serviceName.isEmpty || username.isEmpty || password.isEmpty)
            }
            .padding()
            .navigationDestination(item: $navigateTo) { pw in
                PasswordDetailView(password: pw, viewModel: viewModel)
            }
        }
        .onAppear {
            appLockManager.userInteracted()
        }
        .simultaneousGesture(TapGesture().onEnded {
            appLockManager.userInteracted()
        })
    }

    @ViewBuilder
    private func breachMessageView(text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: text.contains("⚠️") ? "exclamationmark.triangle.fill" : "checkmark.shield.fill")
                .foregroundColor(text.contains("⚠️") ? .red : .green)
            Text(text)
                .foregroundColor(text.contains("⚠️") ? .red : .green)
                .multilineTextAlignment(.leading)
                .font(.subheadline)
        }
        .padding()
        .background(Color(text.contains("⚠️") ? .red.opacity(0.1) : .green.opacity(0.1)))
        .cornerRadius(12)
    }

    private func clearFields() {
        serviceName = ""
        username = ""
        password = ""
        pwnedMessage = nil
        emailBreachMessage = nil
    }
}

#Preview {
    AddPasswordView(isPresented: .constant(true), viewModel: PasswordListViewModel())
}
