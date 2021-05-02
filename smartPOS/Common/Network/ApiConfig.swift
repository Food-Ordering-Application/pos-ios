//
//  ApiConfig.swift
//  SpaceXOdyssey
//
//  Created by Martin Lukacs on 18/12/2018.
//  Copyright © 2018 mdev. All rights reserved.
//

/// Contains all the information related to the general informations of the API
struct APIConfig {
    static let baseUrl = "http://localhost:8000"
//    static let apiVersion = "v3"
    static var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwaG9uZU51bWJlciI6IjA3Njg3NzczNTIiLCJzdWIiOiIxZDViYjEwZC01MDgyLTQ2MjAtYmRmNi03NzM5M2Y5MDg2OGEiLCJpc0N1c3RvbWVyIjp0cnVlLCJpYXQiOjE2MTk4NTUzMzgsImV4cCI6MTYyMTA2NDkzOH0.Qpdazo1NtTyNiW3V_1lSjgMsJ3v19j66jD1p8WgDJM4"
    static let limitDisplay = 20
    static func getBaseUrl() -> String {
//        return "\(baseUrl)\(apiVersion)"
        return "\(baseUrl)"
    }
}
