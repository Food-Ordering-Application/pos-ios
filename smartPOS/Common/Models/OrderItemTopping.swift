//
//  OrderItemTopping.swift
//  smartPOS
//
//  Created by I Am Focused on 17/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
struct OrderItemTopping: Decodable {
    let id: String?
    let state: String?
    let name: String?
    let menuItemToppingId: String?
    let quantity: Int?
    let price: Double?
    var asDictionary: [String: Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map { (label: String?, value: Any) -> (String, Any)? in
            guard let label = label else { return nil }
            return (label, value)
        }.compactMap { $0 })
        return dict
    }
}
