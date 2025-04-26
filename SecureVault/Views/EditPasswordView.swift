//
//  EditPasswordView.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/21/25.
//

import SwiftUI

struct EditPasswordView: View {
    var password: Password
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: PasswordListViewModel // ✅ أضف هذا

    @State private var serviceName: String
    @State private var username: String
    @State private var passwordText: String
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @State private var selectedCategoryID: UUID?
    @State private var selectedDefaultCategory: String? // ✅ لدعم الفئة الافتراضية

    @State private var pwnedMessage: String? = nil
    @State private var emailBreachMessage: String? = nil

    init(password: Password, isPresented: Binding<Bool>, viewModel: PasswordListViewModel) {
        self.password = password
        self._isPresented = isPresented
        self._serviceName = State(initialValue: password.serviceName)
        self._username = State(initialValue: password.username)
        self._passwordText = State(initialValue: password.decryptedPassword() ?? "")
        self.viewModel = viewModel // ✅
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Edit Information")) {
                    TextField("Service Name", text: $serviceName)
                    TextField("Username", text: $username)
                    SecureField("Password", text: $passwordText)
                }
                .headerProminence(.increased)

                Section(header: Text("Category")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            // ✅ الفئات الافتراضية
                            ForEach(CategoryViewModel.defaultCategories, id: \.name) { defaultCategory in
                                HStack(spacing: 6) {
                                    Image(systemName: defaultCategory.icon)
                                    Text(defaultCategory.name)
                                }
                                .padding(8)
                                .background(selectedDefaultCategory == defaultCategory.name ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedDefaultCategory = defaultCategory.name
                                    selectedCategoryID = nil
                                }
                            }

                            // ✅ الفئات المخصصة
                            ForEach(categoryViewModel.categories, id: \.self) { category in
                                HStack(spacing: 6) {
                                    Image(systemName: category.icon ?? "tag.fill")
                                    Text(category.name ?? "")
                                }
                                .padding(8)
                                .background(selectedCategoryID == category.id ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                .cornerRadius(10)
                                .onTapGesture {
                                    selectedCategoryID = category.id
                                    selectedDefaultCategory = nil
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section {
                    Button("Save Changes") {
                        let categoryName: String
                        if let selectedCustom = categoryViewModel.categories.first(where: { $0.id == selectedCategoryID }) {
                            categoryName = selectedCustom.name ?? "Uncategorized"
                        } else if let selectedDefault = selectedDefaultCategory {
                            categoryName = selectedDefault
                        } else {
                            categoryName = "Uncategorized"
                        }
                        CoreDataManager.shared.updatePassword(
                            id: password.id,
                            serviceName: serviceName,
                            username: username,
                            password: passwordText,
                            category: categoryName
                        )
                        isPresented = false
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("Edit Password")
            .onAppear {
                if let matched = categoryViewModel.categories.first(where: { $0.name == password.category }) {
                    selectedCategoryID = matched.id
                    selectedDefaultCategory = nil
                } else {
                    selectedCategoryID = nil
                    selectedDefaultCategory = password.category
                }
            }

            // 🔐 Password breach check
            Button("Check Password Breach") {
                PwnedPasswordChecker.checkPassword(passwordText) { isPwned, count in
                    DispatchQueue.main.async {
                        pwnedMessage = isPwned ?
                            "Found in \(count) breaches!" :
                            "Not found in any breaches."
                    }
                }
            }
            .disabled(passwordText.isEmpty)
            .foregroundColor(.blue)

            if let message = pwnedMessage {
                statusMessageView(text: message, isWarning: message.contains("Found"))
            }

            // 📧 Email breach check
            Button("Check Email Breach") {
                EmailBreachChecker.checkEmailBreach(username) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let breaches):
                            if breaches.isEmpty {
                                emailBreachMessage = "Email not found in any breach."
                            } else {
                                let firstBreaches = breaches.prefix(3)
                                let remainingCount = breaches.count - firstBreaches.count
                                var summary = "Found in: \(firstBreaches.joined(separator: ", "))"
                                if remainingCount > 0 {
                                    summary += " and \(remainingCount) more..."
                                }
                                emailBreachMessage = summary
                            }
                        case .failure(let error):
                            if (error as NSError).code == 429 {
                                emailBreachMessage = "Too many requests. Please wait a moment."
                            } else {
                                emailBreachMessage = "Error: \(error.localizedDescription)"
                            }
                        }
                    }
                }
            }
            .disabled(username.isEmpty)
            .foregroundColor(.orange)

            if let emailMessage = emailBreachMessage {
                statusMessageView(text: emailMessage, isWarning: emailMessage.contains("Found"))
            }
        }
    }

    @ViewBuilder
    private func statusMessageView(text: String, isWarning: Bool) -> some View {
        HStack(spacing: 10) {
            Image(systemName: isWarning ? "exclamationmark.triangle.fill" : "checkmark.seal.fill")
                .foregroundColor(isWarning ? .red : .green)
            Text(text)
                .font(.headline)
                .foregroundColor(isWarning ? .red : .green)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(Color(isWarning ? .red.opacity(0.1) : .green.opacity(0.1)))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

#Preview {
    EditPasswordView(
        password: Password(
            id: UUID(),
            serviceName: "Test Service",
            username: "test@example.com",
            encryptedPassword: Data(),
            createdAt: Date(),
            category: "",
            isFavorite: false
        ),
        isPresented: .constant(true),
        viewModel: PasswordListViewModel() // ✅ أضف هذا السطر
    )
    .environmentObject(CategoryViewModel(context: PersistenceController.shared.context)) // إذا احتجت الـ context
}
