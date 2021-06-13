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
    var status: DeliveryStatus
    var customerId: String?
    var customerAddress: String?
    var note: String? = ""
    var driverId: String?
    var distance: Float?
    var shippingFee: Float?
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
    case draft = "DRAFT"
    case assigning = "ASSIGNING_DRIVER"
    case ongoing = "ON_GOING"
    case pickedup = "PICKED_UP"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
    case expired = "EXPIRED"
    case unknown = "UNKNOWN"
    public init(from decoder: Decoder) throws {
        self = try DeliveryStatus(rawValue: decoder.singleValueContainer().decode(String.self)) ?? .unknown
    }

    static func getType(_ type: String) -> DeliveryStatus {
        switch type {
        case "DRAFT":
            return .draft
        case "ASSIGNING_DRIVER":
            return .assigning
        case "ON_GOING":
            return .ongoing
        case "PICKED_UP":
            return .pickedup
        case "COMPLETED":
            return .completed
        case "CANCELLED":
            return .cancelled
        case "EXPIRED" :
            return .expired
        default:
            return .unknown
        }
    }
}
