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
            return stubbedResponse("Orders")
        case .getOrder:
            return stubbedResponse("Order")
        case .confirmOrder:
            return stubbedResponse("ConfirmOrder")
        case .voidOrder:
            return stubbedResponse("VoidOrder")
        case .syncOrder:
            return stubbedResponse("CSSyncOrder")
        case .createOrderAndOrderItem:
            return stubbedResponse("OrderAndOrderItems")
        case .createOrderItem:
            return stubbedResponse("NewOrderItem")
        case .manipulateOrderItemQuantity:
            return stubbedResponse("ManipulateOrderItem")
        }

    }
}
