//
//  ApiConfig.swift
//  SpaceXOdyssey
//
//  Created by Martin Lukacs on 18/12/2018.
//  Copyright © 2018 mdev. All rights reserved.
//

import Foundation

/// Contains all the information related to the general informations of the API
struct APIConfig {
//    static let baseUrl = "http://iamfocused.local:8000"
    static let baseUrl = "https://apigway.herokuapp.com"
//    static let apiVersion = "v3"
    static let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZU51bWJlciI6IjA3Njg3NzczNTIiLCJzdWIiOiI3NTIwZmZhOS01MDNlLTRkM2QtODc2Zi1mMTEwMmQzODA4M2YiLCJpc0N1c3RvbWVyIjp0cnVlLCJpYXQiOjE2MjIwNDAwMTgsImV4cCI6MTYyMzI0OTYxOH0.O1qB4uuqzHNkWSMCcEN9puH6U7dGK422mSpPZ2gGXco"
//    static let restaurantId = "22691c23-22ba-4496-828d-ed07f4d896c2"
    static let restaurantId = "59648039-fb38-4a5a-8ce7-6938b27b76ab" // MARK: Production
    static let customerId = "3b42a330-4d01-46b8-a288-d52c10d3416d"
    static let channelName = "orders_\(APIConfig.restaurantId)"
    static let limitDisplay = 20
    static let debugMode = true
    static func getBaseUrl() -> String {
//        return "\(baseUrl)\(apiVersion)"
        return "\(baseUrl)"
    }
    
    static func setRestaurantId(restaurantId: String?) {
        UserDefaults.standard.set(restaurantId, forKey: "restaurantId")
    }
    static func getRestaurantId() ->  String {
        return UserDefaults.standard.string(forKey: "restaurantId") ?? ""
    }
    static func setUserId(userId: String?) {
        UserDefaults.standard.set(userId, forKey: "userId")
    }
    static func getUserId() ->  String {
        return UserDefaults.standard.string(forKey: "userId") ?? ""
    }
    static func setToken(token: String?) {
        UserDefaults.standard.set(token, forKey: "token")
    }
    static func getToken() ->  String {
        return UserDefaults.standard.string(forKey: "token") ?? ""
    }
}
