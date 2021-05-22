//
//  CreateOrderAndOrderItemResponse.swift
//  smartPOS
//
//  Created by I Am Focused on 01/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
import SwiftDate
struct CreateOrderAndOrderItemResponse: Decodable {
    let statusCode: Int
    let message: String
    let data: OrderAndOrderItemData
}

struct OrderAndOrderItemData: Decodable {
    let order: NestedOrder?
    var asDictionary: [String: Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map { (label: String?, value: Any) -> (String, Any)? in
            guard let label = label else { return nil }
            if let disValue = value as? NestedOrder {
                return (label, disValue.asDictionary)
            }
            return (label, value)
        }.compactMap { $0 })
        return dict
    }
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
    let createdAt: Date?
    let updatedAt: Date?
    var note: String? = ""
    let orderItems: [OrderItemRes]?
    let delivery: Delivery?
    var asDictionary: [String: Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map { (label: String?, value: Any) -> (String, Any)? in
            guard let label = label else { return nil }
            if let disValue = value as? [OrderItemRes] {
                return (label, disValue.map { (orderItemRes) -> [String: Any] in
                    orderItemRes.asDictionary
                })
            }
            if let disValue = value as? Delivery {
                return (label, disValue.asDictionary)
            }
            if let disValue = value as? OrderStatus {
                return (label, disValue.rawValue)
            }
            if let disValue = value as? PaymentType {
                return (label, disValue.rawValue)
            }
            if let disValue = value as? Date {
                return (label, disValue.toISO())
            }
            
            return (label, value)
        }.compactMap { $0 })
        return dict
    }
}

struct OrderItemRes: Decodable {
    let id: String?
    let menuItemId: String?
    let orderId: String?
    let price: Double?
    let name: String?
    let discount: Float?
    let subTotal: Double?
    let quantity: Int?
    let state: OrderItemStatus?
    let orderItemToppings: [OrderItemTopping]?
    var asDictionary: [String: Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map { (label: String?, value: Any) -> (String, Any)? in
            guard let label = label else { return nil }
            if let disValue = value as? [OrderItemTopping] {
                return (label, disValue.map { (orderItemRes) -> [String: Any] in
                    orderItemRes.asDictionary
                })
            }
            if let disValue = value as? OrderItemStatus {
                return (label, disValue.rawValue)
            }
            return (label, value)
        }.compactMap { $0 })
        return dict
    }
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
