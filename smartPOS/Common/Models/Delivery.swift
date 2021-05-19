//
//  Delivery.swift
//  smartPOS
//
//  Created by I Am Focused on 09/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
struct Delivery: Decodable {
    var id: String?
    var orderId: String?
    var address: String?
    var status: DeliveryStatus
    var customerAddressId: String? = ""
    var note: String? = ""
    var customerId: String?
    var driverId: String?
    var shippingFee: Float?
    var geom: String?
    var total: Double?
    var createdAt: Date?
    var updatedAt: Date?
    var deliveredAt: Date?
}

enum DeliveryStatus: String, Decodable {
    case waitingDriver = "WAITING_DRIVER"
    case picking = "PICKING"
    case delivering = "DELIVERING"
    case delivered = "DELIVIRED"
    case cancelled = "CANCELLED"
    case unknown = "UNKNOWN"
    public init(from decoder: Decoder) throws {
        self = try DeliveryStatus(rawValue: decoder.singleValueContainer().decode(String.self)) ?? .unknown
    }

    static func getType(_ type: String) -> DeliveryStatus {
        switch type {
        case "WAITING_DRIVER":
            return .waitingDriver
        case "PICKING":
            return .picking
        case "DELIVERING":
            return .delivering
        case "DELIVIRED":
            return .delivered
        case "CANCELLED":
            return .cancelled
        default:
            return .unknown
        }
    }
}
