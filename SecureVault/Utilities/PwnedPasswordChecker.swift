//
//  PwnedPasswordChecker.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/23/25.
//
import Foundation
import CryptoKit

class PwnedPasswordChecker {
    static func checkPassword(_ password: String, completion: @escaping (Bool, Int) -> Void) {
        let hash = Insecure.SHA1.hash(data: password.data(using: .utf8)!)
            .map { String(format: "%02hhx", $0) }
            .joined()
            .uppercased()

        let prefix = String(hash.prefix(5))
        let suffix = String(hash.dropFirst(5))

        guard let url = URL(string: "https://api.pwnedpasswords.com/range/\(prefix)") else {
            completion(false, 0)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                let data = data,
                let responseString = String(data: data, encoding: .utf8)
            else {
                completion(false, 0)
                return
            }

            let lines = responseString.components(separatedBy: "\r\n")
            for line in lines {
                let components = line.components(separatedBy: ":")
                if components.count == 2, components[0] == suffix {
                    let count = Int(components[1]) ?? 0
                    completion(true, count)
                    return
                }
            }

            completion(false, 0)
        }

        task.resume()
    }
}
