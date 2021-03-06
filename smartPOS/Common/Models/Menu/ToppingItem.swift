//
//  ToppingItem.swift
//  smartPOS
//
//  Created by I Am Focused on 14/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation

typealias ToppingItems = [ToppingItem]
struct ToppingItem: Decodable {
    var id: String
    var name: String
    var description: String
    var price: Double
    var maxQuantity: Int
//    var isActive: Bool? = true
    var state: ItemState? = .instock
    //    var index: Float
    //    var menuItemToppings: [MenuItemTopping]
}
