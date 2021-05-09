//
//  OrdersResponse.swift
//  smartPOS
//
//  Created by I Am Focused on 08/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation

//struct OrdersRequest: Decodable {
//
//}

struct OrdersResponse: Decodable {
    let statusCode: Int
    let message: String
    let data: OrdersData
}
struct OrdersData: Decodable {
    let orders: Orders
}
