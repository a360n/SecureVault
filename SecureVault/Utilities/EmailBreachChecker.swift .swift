//
//  EmailBreachChecker.swift .swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/23/25.
//

import Foundation

struct Breach: Codable {
    let Name: String
}

class EmailBreachChecker {
    static let apiKey = "8847f25ea66e4d0faf5acd191f867360" 
    static func checkEmailBreach(_ email: String, completion: @escaping (Result<[String], Error>) -> Void) {
        guard let url = URL(string: "https://haveibeenpwned.com/api/v3/breachedaccount/\(email.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "hibp-api-key")
        request.addValue("SecureVaultApp", forHTTPHeaderField: "user-agent")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: -1)))
                return
            }

            switch httpResponse.statusCode {
            case 200:
                if let data = data,
                   let breaches = try? JSONDecoder().decode([Breach].self, from: data) {
                    let names = breaches.map { $0.Name }
                    completion(.success(names))
                } else {
                    completion(.success([]))
                }

            case 404:
                completion(.success([]))

            default:
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode)))
            }
        }.resume()
    }
}
