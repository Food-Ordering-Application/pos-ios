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
    static let baseUrl = "https://apigway.herokuapp.com"
//    static let apiVersion = "v3"
    static let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZU51bWJlciI6IjA3Njg3NzczNTIiLCJzdWIiOiJiMzIyOTVlOS1jYjU3LTQ3YWEtYmFlOC0wNDJkZTJjNzk4NzciLCJpc0N1c3RvbWVyIjp0cnVlLCJpYXQiOjE2MjA0OTI0NTcsImV4cCI6MTYyMTcwMjA1N30.2HiJYhbC8Z3i9iW9D7z_9dPEfzC1V6iXj1jhKPsKBNU"
    static let restaurantId = "ad7fecdf-c88c-4d78-b54e-98cc63304ab3"
    static let customerId = "7520ffa9-503e-4d3d-876f-f1102d38083f"
    static let limitDisplay = 20
    static func getBaseUrl() -> String {
//        return "\(baseUrl)\(apiVersion)"
        return "\(baseUrl)"
    }
}
