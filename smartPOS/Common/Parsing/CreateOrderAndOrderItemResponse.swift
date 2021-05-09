//
//  CreateOrderAndOrderItemResponse.swift
//  smartPOS
//
//  Created by I Am Focused on 01/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
struct CreateOrderAndOrderItemResponse: Decodable {
    let statusCode: Int
    let message: String
    let data: OrderAndOrderItemData
}

struct OrderAndOrderItemData: Decodable {
    let order: NestedOrder?
}

struct NestedOrder: Decodable {
    let id: String?
    let status: OrderStatus?
    let cashierId: String?
    let restaurantId: String?
    let paymentType: PaymentType?
    let serviceFee: Float?
    let subTotal: Double?
    let grandTotal: Double?
    let itemDiscount: Float?
    let discount: Float?
    let createdAt: SafeDateCodableType?
    let updatedAt: SafeDateCodableType?
    let orderItems: [OrderItemRes]?
    let delivery: Delivery?
}

struct OrderItemRes: Decodable {
    let id: String?
    let menuItemId: String?
    let orderId: String?
    let price: Double?
    let discount: Float?
    let quantity: Int?
    let orderItemToppings: [OrderItemTopping]?
}
 
public struct SafeDateCodableType: Decodable {
    public var dateValue: Date?
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer() {
            dateValue = try? container.decode(Date.self)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let date = dateValue {
            try container.encode(date)
        }
    }
}
