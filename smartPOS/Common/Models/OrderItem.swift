//
//  File.swift
//  smartPOS
//
//  Created by I Am Focused on 17/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
struct OrderItem: Decodable {
    let id: String?
    let menuItemId: String?
    let name: String?
    let orderId: String?
    let price: Double?
    let discount: Float?
    let subTotal: Double?
    let state: OrderItemStatus?
    let quantity: Int?
    let note: String?
}
enum OrderItemStatus: String, Decodable {
    case instock = "IN_STOCK"
    case unknown = "UNKNOWN"
    public init(from decoder: Decoder) throws {
        self = try OrderItemStatus(rawValue: decoder.singleValueContainer().decode(String.self)) ?? .unknown
    }
}
