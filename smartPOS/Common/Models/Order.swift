//
//  Order.swift
//  smartPOS
//
//  Created by Raymond Law on 2/12/19.
//  Copyright © 2019 Clean Swift LLC. All rights reserved.
//

import Foundation
typealias Orders = [Order]
struct Order: Decodable {
    var id: String?
    var cashierId: String?
    var restaurantId: String?
    var subTotal: Double?
    var itemDiscount: Float?
    var serviceFee: Float?
    var discount: Float?
    var grandTotal: Double
//    var paymentMode: PaymentMode?
    var paymentType: PaymentType?
    var status: OrderStatus?
    var createdAt: Date?
    var updatedAt: Date?
    var note: String? = ""
    var delivery: Delivery?
    
//    var promotionId: String?
//    var deliveredAt: SafeDateCodableType?
//    var customerAddressId: String? = ""
//    var note: String? = ""
//    var customerId: String?
//    var driverId: String?
//    var shippingFee: Float?

//    enum CodingKeys: String, CodingKey {
//        case id
//        case customerId = "customer_id"
//        case driverId = "driver_id"
//        case subTotal = "sub_total"
//        case itemDiscount = "item_discount"
//        case shippingFee = "shipping_fee"
//        case serviceFee = "service_fee"
//        case promotionId = "promotion_id"
//        case discount
//        case grandTotal = "grand_total"
//        case customerAddressId = "customer_address_id"
//        case paymentMode = "payment_mode"
//        case paymentType = "payment_type"
//        case status
//        case note
//        case createdAt = "created_at"
//        case deliveredAt = "delivered_at"
//        case updatedAt = "updated_at"
//    }
}

enum OrderStatus: String, Decodable {
    case draft = "DRAFT"
    case ordered = "ORDERED"
    case checking = "CHECKING"
    case delivering = "DELIVERING"
    case cancelled = "CANCELLED"
    case complete = "COMPLETE"
    case unknown = "UNKNOWN"
    public init(from decoder: Decoder) throws {
        self = try OrderStatus(rawValue: decoder.singleValueContainer().decode(String.self)) ?? .unknown
    }

    static func getType(_ type: String) -> OrderStatus {
        switch type {
        case "DRAFT":
            return .draft
        case "ORDERED":
            return .ordered
        case "CHECKING":
            return .checking
        case "DELIVERING":
            return .delivering
        case "COMPLETE" :
            return .complete 
        case "CANCELLED":
            return .cancelled
        default:
            return .unknown
        }
    }
}

enum PaymentMode: String, Decodable {
    case cod = "COD"
    case preorder = "PREORDER"
    case unknown = "UNKNOWN"
    public init(from decoder: Decoder) throws {
        self = try PaymentMode(rawValue: decoder.singleValueContainer().decode(String.self)) ?? .unknown
    }
}

enum PaymentType: String, Decodable {
    case cod = "COD"
    case momo = "MOMO"
    case paypal = "PAYPAL"
    case unknown = "UNKNOWN"
    public init(from decoder: Decoder) throws {
        self = try PaymentType(rawValue: decoder.singleValueContainer().decode(String.self)) ?? .unknown
    }
}
