//
//  ToppingItem.swift
//  smartPOS
//
//  Created by I Am Focused on 14/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
struct ToppingItem: Decodable {
    var id: String
    var description: String
    var price: Double
    var maxQuantity: Int
    var index: Float
    var isActive: Bool
    var menuItemToppings: [MenuItemTopping]
}
