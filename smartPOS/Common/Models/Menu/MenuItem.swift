//
//  MenuItem.swift
//  smartPOS
//
//  Created by I Am Focused on 14/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import CoreData
import CoreStore
import Foundation

typealias MenuItems = [MenuItem]
struct MenuItem: Decodable {
    var id: String = ""
    var name: String = "Menu item name"
    var description: String = "Menu item description"
    var price: Double = 100000
    var imageUrl: String = "pizza"
//    var index: Float?
    var isActive: Bool? = true
    var state: ItemState? = .instock
}


enum ItemState: String, Decodable {
    case instock = "IN_STOCK"
    case outofstock = "OUT_OF_STOCK"
    case unknown = "UNKNOWN"
    public init(from decoder: Decoder) throws {
        self = try ItemState(rawValue: decoder.singleValueContainer().decode(String.self)) ?? .unknown
    }

    static func getType(_ type: String) -> ItemState {
        switch type {
        case "IN_STOCK":
            return .instock
        case "OUT_OF_STOCK":
            return .outofstock
        default:
            return .unknown
        }
    }
}
