import SwiftUI

struct PasswordListView: View {
    @StateObject private var viewModel = PasswordListViewModel()
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @State private var isAdding = false
    
    @EnvironmentObject var appLockManager: AppLockManager

    var defaultCategories: [String] {
        CategoryViewModel.defaultCategories.map { $0.name } // Safely unwrap optional
    }

    var customCategories: [CategoryEntity] {
        guard !categoryViewModel.categories.isEmpty else { return [] }
        return categoryViewModel.categories.filter {
            guard let name = $0.name else { return false } // Safely unwrap optional
            return !defaultCategories.contains(name)
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                favoritesToggle
                categoryScrolls
                passwordList
            }
            .padding(.top)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Passwords")
            .searchable(text: $viewModel.searchText, prompt: "Search services or usernames")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    settingsButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
        }
    }

    private var favoritesToggle: some View {
        Toggle("Show Favorites Only", isOn: $viewModel.showFavoritesOnly)
            .toggleStyle(.switch)
            .padding(.horizontal)
    }

    private var categoryScrolls: some View {
        VStack(spacing: 6) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(CategoryViewModel.defaultCategories, id: \.name) { category in
                        let isSelected = viewModel.selectedCategory == category.name
                        Label(category.name, systemImage: category.icon)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                            .cornerRadius(16)
                            .onTapGesture {
                                viewModel.selectedCategory = category.name // سيضبط على "All" عند الضغط
                            }
                    }
                }
                .padding(.horizontal)
            }
            .contentShape(Rectangle())

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(customCategories, id: \.self) { customCategory in
                        Label {
                            Text(customCategory.name ?? "")
                        } icon: {
                            Image(systemName: isValidSystemIcon(customCategory.icon) ? customCategory.icon! : "tag.fill")
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(viewModel.selectedCategory == customCategory.name ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
                        .cornerRadius(16)
                        .onTapGesture {
                            viewModel.selectedCategory = customCategory.name ?? ""
                        }
                    }
                }
                .padding(.horizontal)
            }
            .contentShape(Rectangle())
            
        }
    }

    private var passwordList: some View {
        List {
            ForEach(viewModel.filteredPasswords) { password in
                NavigationLink(destination: PasswordDetailView(password: password, viewModel: viewModel)) {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(CategoryStyle.color(for: password.category).opacity(0.2))
                                .frame(width: 36, height: 36)

                            Image(systemName: CategoryStyle.icon(for: password.category))
                                .foregroundColor(CategoryStyle.color(for: password.category))
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                if password.isFavorite {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                }
                                Text(password.serviceName)
                                    .font(.headline)
                            }
                            Text(password.username)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .onDelete(perform: viewModel.deletePassword)
        }
        .listStyle(.plain)
    }

    private var settingsButton: some View {
        NavigationLink(destination: SettingsView()
            .environment(\.managedObjectContext, categoryViewModel.managedObjectContext)
        ) {
            Image(systemName: "gear")
                .imageScale(.large)
        }
    }

    private var addButton: some View {
        Button(action: { isAdding = true }) {
            Image(systemName: "plus")
                .imageScale(.large)
        }
        .sheet(isPresented: $isAdding) {
            AddPasswordView(isPresented: $isAdding, viewModel: viewModel)
        }
    }
}


