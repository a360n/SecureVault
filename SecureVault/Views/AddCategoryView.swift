//
//  AddCategoryView.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/22/25.
//

import SwiftUI

struct AddCategoryView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @Environment(\.dismiss) var dismiss

    @State private var categoryName: String = ""
    @State private var selectedIcon: String = "tag.fill"

    let availableIcons = [
        "tag.fill", "briefcase.fill", "person.fill", "message.fill", "creditcard.fill",
        "lock.fill", "globe", "book.fill", "graduationcap.fill", "airplane", "gamecontroller.fill"
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // ✅ اسم الفئة
                VStack(alignment: .leading, spacing: 8) {
                    Text("Category Name")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    TextField("Enter category name", text: $categoryName)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                }
                .padding(.horizontal)

                // ✅ اختيار الأيقونة
                VStack(alignment: .leading, spacing: 8) {
                    Text("Choose an Icon")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(availableIcons, id: \.self) { icon in
                                ZStack {
                                    Circle()
                                        .fill(icon == selectedIcon ? Color.blue.opacity(0.2) : Color.clear)
                                        .frame(width: 60, height: 60)
                                        .overlay(
                                            Circle()
                                                .stroke(icon == selectedIcon ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                                        )

                                    Image(systemName: icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 28, height: 28)
                                        .foregroundColor(.primary)
                                }
                                .onTapGesture {
                                    selectedIcon = icon
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.horizontal)

                Spacer()

                // ✅ زر الإضافة
                Button(action: saveCategory) {
                    Text("Add Category")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(categoryName.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray.opacity(0.3) : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .disabled(categoryName.trimmingCharacters(in: .whitespaces).isEmpty)

                Spacer(minLength: 16)
            }
            .padding(.top)
            .navigationTitle("Add Category")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }

    private func saveCategory() {
        let newCategory = CategoryEntity(context: managedObjectContext)
        newCategory.id = UUID()
        newCategory.name = categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        newCategory.icon = selectedIcon

        do {
            try managedObjectContext.save()
            categoryViewModel.fetchCategories()
            dismiss()
        } catch {
            print("❌ Failed to save category: \(error.localizedDescription)")
        }
    }
}
#Preview {
    AddCategoryView()
}

