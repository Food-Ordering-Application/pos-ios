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
    var asDictionary: [String: Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map { (label: String?, value: Any) -> (String, Any)? in
            guard let label = label else { return nil }
            if let disValue = value as? DeliveryStatus {
                return (label, disValue.rawValue)
            }
            if let disValue = value as? Date {
                return (label, disValue.toString())
            }
            return (label, value)
        }.compactMap { $0 })
        return dict
    }
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
