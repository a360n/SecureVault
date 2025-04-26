//
//  DataSeeder.swift
//  SecureVault
//
//  Created by Ali Al-Khazali on 3/28/25.
//

import Foundation
import CoreData

class DataSeeder {
    static func seedPasswords(context: NSManagedObjectContext) {
        let coreDataManager = CoreDataManager.shared

        let allPasswords: [(String, String, String, String)] = [
            // Work
            ("Slack", "work@company.com", "SlackPass123!", "Work"),
            ("Zoom", "meeting@company.com", "ZoomPass456!", "Work"),
            ("GitHub", "dev@company.com", "CodeStrong789$", "Work"),
            ("Notion", "notes@company.com", "OrganizeMe!", "Work"),
            ("Trello", "pm@company.com", "CardsFlow321!", "Work"),

            // Personal
            ("Netflix", "ali@gmail.com", "NetflixMeNow!", "Personal"),
            ("Spotify", "ali.music@gmail.com", "SoundLover22!", "Personal"),
            ("Amazon", "ali@shopping.com", "BuyItAll77$", "Personal"),
            ("YouTube", "ali.video@gmail.com", "WatchMe99!", "Personal"),
            ("Apple ID", "ali@icloud.com", "iLoveMac123!", "Personal"),

            // Social
            ("Facebook", "ali.fb@gmail.com", "MyFBSecret@", "Social"),
            ("Twitter", "ali.tweet@gmail.com", "XMaster321", "Social"),
            ("Instagram", "ali.ig@gmail.com", "InstaStrong!", "Social"),
            ("Snapchat", "ali.snap@gmail.com", "SnapLife44!", "Social"),
            ("Reddit", "ali.reddit@gmail.com", "MemeKing007!", "Social"),

            // Banking
            ("PayPal", "ali.pay@gmail.com", "PayMeSafe22$", "Banking"),
            ("Bank of America", "ali.bank@gmail.com", "BankSecure99!", "Banking"),
            ("Chime", "ali.chime@gmail.com", "MobileBank88", "Banking"),
            ("CashApp", "ali.cash@gmail.com", "CashOn123!", "Banking"),
            ("Venmo", "ali.venmo@gmail.com", "SplitBill22!", "Banking"),

            // Uncategorized
            ("AliExpress", "ali.shop@gmail.com", "ChinaShop44!", "Uncategorized"),
            ("eBay", "ali.ebay@gmail.com", "BidFast33!", "Uncategorized"),
            ("Quora", "ali.ask@gmail.com", "AskItRight!", "Uncategorized"),
            ("Fiverr", "ali.fiverr@gmail.com", "Freelance99!", "Uncategorized"),
            ("Canva", "ali.design@gmail.com", "DesignPro!", "Uncategorized"),

            // Finance & Wallets
            ("Binance", "ali.crypto@gmail.com", "CryptoKing2025", "Finance & Wallets"),
            ("MetaMask", "ali.eth@gmail.com", "MetaSecure88!", "Finance & Wallets"),
            ("Revolut", "ali.fx@gmail.com", "RevolutSafe77", "Finance & Wallets"),
            ("Wise", "ali.wise@gmail.com", "WiseMove321!", "Finance & Wallets"),
            ("Zelle", "ali.zelle@gmail.com", "QuickPay90", "Finance & Wallets"),

            // Gaming
            ("Steam", "ali.gaming@gmail.com", "GameTime99", "Gaming"),
            ("Epic Games", "ali.epic@gmail.com", "Fortnite456!", "Gaming"),
            ("PlayStation", "ali.ps@gmail.com", "PSNPass333", "Gaming"),
            ("Xbox", "ali.xbox@gmail.com", "HaloFan22", "Gaming"),
            ("Twitch", "ali.stream@gmail.com", "TwitchOn66", "Gaming"),

            // Travel
            ("Airbnb", "ali.travel@gmail.com", "StayEasy77", "Travel"),
            ("Booking.com", "ali.booking@gmail.com", "TripNow88", "Travel"),
            ("Uber", "ali.ride@gmail.com", "RideFast123", "Travel"),
            ("Lyft", "ali.lyft@gmail.com", "DriveMe11", "Travel"),
            ("TripAdvisor", "ali.advisor@gmail.com", "TravelGuide2025", "Travel"),

            // Programming
            ("StackOverflow", "ali.dev@gmail.com", "CodeItWell!", "Programming"),
            ("GitLab", "ali.gitlab@gmail.com", "LabPass99", "Programming"),
            ("VS Code Sync", "ali.code@gmail.com", "SyncDev123", "Programming"),
            ("HackerRank", "ali.hr@gmail.com", "SolveIt321!", "Programming"),
            ("LeetCode", "ali.leetcode@gmail.com", "AlgoMaster!", "Programming")
        ]

        for (service, email, pass, category) in allPasswords {
            coreDataManager.addPassword(serviceName: service, username: email, password: pass, category: category)
        }

        print("✅ Seeded \(allPasswords.count) passwords.")
    }
}
