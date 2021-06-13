//
//  MenuItemTopping.swift
//  smartPOS
//
//  Created by I Am Focused on 14/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
typealias MenuItemToppings = [MenuItemTopping]
struct MenuItemTopping: Decodable {
    var id: String
    var menuItem: MenuItem?
    var toppingItem: ToppingItem?
    var customPrice: Double
}
