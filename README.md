SecureVault

SecureVault is a secure and private password manager built using **SwiftUI** and **CoreData**.  
It ensures your sensitive data stays encrypted and protected locally on your device.

---

Features
- AES-256 Encryption for all passwords
- Master password with optional Face ID / Touch ID unlocking
- Categorize passwords (Work, Personal, Social, Banking, etc.)
- Password strength analyzer
- Check if passwords and emails were exposed via HaveIBeenPwned API
- Securely export passwords when needed
- Beautiful SwiftUI interface with light/dark mode support
- Full offline functionality (no server dependency)

---

Requirements
- iOS 16.0+
- Xcode 15+
- Swift 5.9+
- Target Devices: iPhone (no iPad support)

---

Security Highlights
- All passwords are encrypted locally using AES-256
- Master passcode stored securely in Apple's Keychain
- Biometric authentication support (Face ID / Touch ID)
- Optional breach checking without sending actual passwords
- Auto-lock on inactivity

---

Project Architecture
- Built using SwiftUI and MVVM design pattern
- CoreData for local storage
- LocalAuthentication framework for biometrics
- CryptoKit for encryption operations

---

Author
Developed by **Ali Al-Khazali (Blue Software)**

SecureVault does not upload or share any user data externally.

---

Final Word
If you like this project, consider giving it a ⭐️ on GitHub!  
Feedback, issues, and suggestions are always welcome 
