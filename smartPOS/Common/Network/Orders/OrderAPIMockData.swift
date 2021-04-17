//
//  LauncheAPIMockData.swift
//  SpaceXOdyssey
//
//  Created by Martin Lukacs on 18/12/2018.
//  Copyright © 2018 mdev. All rights reserved.
//

import Foundation

extension OrderAPI {
    var sampleData: Data {
        switch self {
        case .getAllOrders:
            return stubbedResponse("Launches")
        case .getOrder:
            return stubbedResponse("Launch")
        }
    }
}
