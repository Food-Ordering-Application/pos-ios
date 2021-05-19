//
//  CSMenuItemToppingsResponce.swift
//  smartPOS
//
//  Created by I Am Focused on 16/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
struct CSMenuItemToppingsResponce: Decodable {
    let statusCode: Int
    let message: String
    let data: CSMenuItemToppingsData?
}


struct CSMenuItemToppingsData: Decodable {
    let results: MenuItemToppingResults
}

typealias MenuItemToppingResults = [MenuItemToppingData]
struct MenuItemToppingData: Decodable {
    var id: String
    var customPrice: Double
    var menuItemId: String
    var toppingItemId: String
}


