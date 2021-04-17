//
//  Order.swift
//  smartPOS
//
//  Created by Raymond Law on 2/12/19.
//  Copyright © 2019 Clean Swift LLC. All rights reserved.
//

import Foundation
typealias Orders = [Order]
struct Order: Codable {
    var id: String?
    var customerId: String
    var driverId: String
    var subTotal: Float
    var itemDiscount: Float
    var shippingFee: Float
    var serviceFee: Float
    var promotionId: String
    var discount: Float
    var grandTotal: Float
    var customerAddressId: String
    var paymentMode: PaymentMode
    var paymentType: PaymentType
    var status: OrderStatus
    var note: String
    var createdAt: Date
    var deliveredAt: Date
    var updatedAt: Date
    
}
enum OrderStatus: Int, Codable {
    case draft = 0
    case ordered = 1
    case checking = 2
    case delivering = 3
    case cancelled = 4
    case unknown = -1
    public init(from decoder: Decoder) throws {
        self = try OrderStatus(rawValue: decoder.singleValueContainer().decode(Int.self)) ?? .unknown
    }
    static func getType(_ type: Int) -> OrderStatus {
        switch type {
        case 0:
            return .draft
        case 1:
            return .ordered
        case 2:
            return .checking
        case 3:
            return .delivering
        case 4:
            return .cancelled
        default:
            return .unknown
        }
    }
}
enum PaymentMode: Int, Codable {
    case cod = 0
    case preorder = 1
    case unknown = -1
    public init(from decoder: Decoder) throws {
        self = try PaymentMode(rawValue: decoder.singleValueContainer().decode(Int.self)) ?? .unknown
    }
}
enum PaymentType: Int, Codable {
    case cod = 0
    case momo = 1
    case paypal = 2
    case unknown = -1
    public init(from decoder: Decoder) throws {
        self = try PaymentType(rawValue: decoder.singleValueContainer().decode(Int.self)) ?? .unknown
    }
}

