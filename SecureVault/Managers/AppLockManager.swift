//
//  AppLockManager.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/21/25.
//
import Foundation
import Combine

class AppLockManager: ObservableObject {
    static let shared = AppLockManager()
    
    private let passcodeKey = "SecureVaultPasscode"
    private let autoLockInterval: TimeInterval = 3600
    private var timer: DispatchSourceTimer?

    @Published var isLocked = true

    private init() {}

    var currentPasscode: String {
        UserDefaults.standard.string(forKey: passcodeKey) ?? "1234" // رمز افتراضي
    }

    func unlock(with input: String) -> Bool {
        if verifyPasscode(input) {
            isLocked = false
            resetTimer()
            return true
        } else {
            return false
        }
    }

    func verifyPasscode(_ input: String) -> Bool {
        input == currentPasscode
    }

    func updatePasscode(to newPasscode: String) {
        UserDefaults.standard.setValue(newPasscode, forKey: passcodeKey)
        print("🔐 New passcode saved: \(newPasscode)")
    }

    func lock() {
        print("🔒 App Locked!")
        isLocked = true
        cancelTimer()
    }

    func userInteracted() {
        print("🟢 User interaction detected")
        if !isLocked {
            resetTimer()
        }
    }

    func resetTimer() {
        print("🔁 New Dispatch Timer started")
        cancelTimer()

        let queue = DispatchQueue(label: "com.securevault.timer")
        let newTimer = DispatchSource.makeTimerSource(queue: queue)
        newTimer.schedule(deadline: .now() + autoLockInterval)
        newTimer.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                if let self = self, !self.isLocked {
                    self.lock()
                }
            }
        }

        newTimer.resume()
        timer = newTimer
    }

    private func cancelTimer() {
        if let timer = timer {
            print("🧹 Dispatch timer cancelled")
            timer.cancel()
            self.timer = nil
        }
    }
}
