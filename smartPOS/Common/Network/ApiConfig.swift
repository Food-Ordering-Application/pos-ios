//
//  ApiConfig.swift
//  SpaceXOdyssey
//
//  Created by Martin Lukacs on 18/12/2018.
//  Copyright © 2018 mdev. All rights reserved.
//

/// Contains all the information related to the general informations of the API
struct APIConfig {
    
    static let baseUrl = "https://api.spacexdata.com/"
    static let apiVersion = "v3"
    static let limitDisplay = 20
    
    static func getBaseUrl() -> String {
        return "\(baseUrl)\(apiVersion)"
    }
}
