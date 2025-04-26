//
//  CategoryManagerView.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/22/25.
//

import SwiftUI

struct CategoryManagerView: View {
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @State private var showingAddCategory = false

    var defaultNames: [String] {
        CategoryViewModel.defaultCategories.map { $0.name  }
    }

    var customCategories: [CategoryEntity] {
        categoryViewModel.categories.filter { !defaultNames.contains($0.name ?? "") }
    }

    var body: some View {
        NavigationStack {
            VStack {
                if customCategories.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "folder.badge.plus")
                            .font(.system(size: 48))
                            .foregroundColor(.blue)
                        Text("No custom categories yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text("Tap + to add your first one")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(customCategories, id: \.self) { category in
                                HStack(spacing: 16) {
                                    Image(systemName: category.icon ?? "tag.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.blue)
                                        .frame(width: 32, height: 32)
                                        .background(Circle().fill(Color.blue.opacity(0.1)))
                                    
                                    Text(category.name ?? "")
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        categoryViewModel.deleteCategory(category)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemGray6)))
                                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }
                }

                NavigationLink(destination: AddCategoryView()
                    .environment(\.managedObjectContext, categoryViewModel.managedObjectContext)
                    .environmentObject(categoryViewModel)
                ) {
                    Label("Add Category", systemImage: "plus")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
            }
            .navigationTitle("Manage Categories")
            .onAppear {
                print("📂 CategoryManagerView appeared")
            }
        }
    }
}



