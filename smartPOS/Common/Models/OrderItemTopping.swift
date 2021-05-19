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
}
