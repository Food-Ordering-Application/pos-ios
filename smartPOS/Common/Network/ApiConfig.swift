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
    static let restaurantId = "59648039-fb38-4a5a-8ce7-6938b27b76ab"
    static let customerId = "e4ed3a77-18b9-4f3c-a0e1-69dda7cf1a0b"
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
