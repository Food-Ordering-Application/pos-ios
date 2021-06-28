//
//  ApiConfig.swift
//  SpaceXOdyssey
//
//  Created by Martin Lukacs on 18/12/2018.
//  Copyright © 2018 mdev. All rights reserved.
//

import Foundation
import SwiftDate
/// Contains all the information related to the general informations of the API
struct APIConfig {
//    static let baseUrl = "http://iamfocused.local:8000"
    static let baseUrl = "https://apigway.herokuapp.com"
//    static let apiVersion = "v3"
    static let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZU51bWJlciI6IjA3Njg3NzczNTIiLCJzdWIiOiI5NzYzYzgyMS1hOWYwLTQ1MWQtYmFmNy1kZjMxMzU4Y2NhMjciLCJpc0N1c3RvbWVyIjp0cnVlLCJpYXQiOjE2MjMyOTEwNTgsImV4cCI6MTYyNDUwMDY1OH0.uAashljP-UHEK4xQIYWIs7cbE7Wpc-Eb3vF6Q7nNy0A"
//    static let restaurantId = "0963cd4b-bf91-4080-bcce-83c957077551" // MARK: Development

    static let restaurantId = "59648039-fb38-4a5a-8ce7-6938b27b76ab" // MARK: Production
    static let merchantId = "5baf057d-0314-4a63-b08e-2cecb8a55bd2"
    static let userId = "d409255a-7067-4ea9-81d0-3faf8a5d7a06"
    static let channelName = "orders_\(String(describing: APIConfig.getRestaurantId()))"
    static let limitDisplay = 20
    static let debugMode = true
    static func getBaseUrl() -> String {
        return "\(baseUrl)"
    }

    static func setRestaurantId(restaurantId: String?) {
        UserDefaults.standard.set(restaurantId, forKey: "restaurantId")
    }
    // MARK: Do not hard code
    static func getRestaurantId() -> String {
        return UserDefaults.standard.string(forKey: "restaurantId") ?? APIConfig.restaurantId
//        return  APIConfig.restaurantId
    }

    static func setUserId(userId: String?) {
        UserDefaults.standard.set(userId, forKey: "userId")
    }
    // MARK: Do not hard code
    static func getUserId() -> String {
        return UserDefaults.standard.string(forKey: "userId") ?? ""
    }

    static func setUserName(_ name: String?) {
        UserDefaults.standard.set(name, forKey: "_userName")
    }
    static func getUserName() -> String? {
        return UserDefaults.standard.string(forKey: "_userName")
    }
    static func setMerchantId(merchantId: String?) {
        UserDefaults.standard.set(merchantId, forKey: "merchantId")
    }

    static func getMerchantId() -> String {
        return UserDefaults.standard.string(forKey: "merchantId") ?? ""
    }

    static func setToken(token: String?) {
        UserDefaults.standard.set(token, forKey: "token")
    }
    // MARK: Do not hard code
    static func getToken() -> String {
        return UserDefaults.standard.string(forKey: "token") ?? ""
    }
    
    static func setLatestSync(latestSync: Date?) {
        let date = latestSync?.toRSS(alt: true)
        UserDefaults.standard.set(date, forKey: "latestSync")
    }
    
    static func getLatestSync() -> Date? {
        let latestSync = UserDefaults.standard.string(forKey: "latestSync")
        return latestSync?.toRSSDate(alt: true)?.date
    }
    static func setIsSynced(_ isSynced: Bool?) {
        UserDefaults.standard.set(isSynced, forKey: "isSynced")
    }
    // MARK: Do not hard code
    static func getIsSynced() -> Bool? {
        return UserDefaults.standard.bool(forKey: "isSynced")
    }
}
