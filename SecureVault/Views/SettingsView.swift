import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appLockManager: AppLockManager
    @EnvironmentObject var categoryViewModel: CategoryViewModel
    @State private var showingAddCategory = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                SectionBox(title: "About") {
                    LabeledTextRow(icon: "info.circle", text: "Version 1.0.0")
                    LabeledTextRow(icon: "person.crop.circle", text: "Secure Vault by Blue Software")
                }

                SectionBox(title: "Categories") {
                    LabeledNavigationLink(icon: "folder.badge.plus", label: "Manage Categories") {
                        CategoryManagerView()
                            .environment(\.managedObjectContext, categoryViewModel.managedObjectContext)
                            .environmentObject(categoryViewModel)
                    }
                }

                SectionBox(title: "Security") {
                    LabeledButton(icon: "lock.fill", label: "Lock App Now") {
                        appLockManager.lock()
                    }

                    LabeledNavigationLink(icon: "key.fill", label: "Change Passcode") {
                        ChangePasscodeView()
                    }
                }

                SectionBox(title: "About the App") {
                    LabeledNavigationLink(icon: "shield.fill", label: "What is SecureVault?") {
                        AboutAppView()
                    }

                    LabeledNavigationLink(icon: "doc.text", label: "Terms & Conditions") {
                        TermsAndConditionsView()
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top)
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppLockManager.shared)
        .environmentObject(CategoryViewModel(context: PersistenceController.shared.context)) // Pass context here
}
