//
//  ApiConfig.swift
//  SpaceXOdyssey
//
//  Created by Martin Lukacs on 18/12/2018.
//  Copyright © 2018 mdev. All rights reserved.
//

/// Contains all the information related to the general informations of the API
struct APIConfig {
//    static let baseUrl = "http://iamfocused.local:8000"
    static let baseUrl = "https://api-gateway-pos.herokuapp.com"
//    static let apiVersion = "v3"
    static let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZU51bWJlciI6IjA3Njg3NzczNTIiLCJzdWIiOiJiMzIyOTVlOS1jYjU3LTQ3YWEtYmFlOC0wNDJkZTJjNzk4NzciLCJpc0N1c3RvbWVyIjp0cnVlLCJpYXQiOjE2MjA0OTI0NTcsImV4cCI6MTYyMTcwMjA1N30.2HiJYhbC8Z3i9iW9D7z_9dPEfzC1V6iXj1jhKPsKBNU"
    static let restaurantId = "32f49431-e572-4cbb-8f04-34bf858ef3de"
    static let customerId = "942356b0-1738-47ad-b1b7-8b45f73912b6"
    static let limitDisplay = 20
    static func getBaseUrl() -> String {
//        return "\(baseUrl)\(apiVersion)"
        return "\(baseUrl)"
    }
}
