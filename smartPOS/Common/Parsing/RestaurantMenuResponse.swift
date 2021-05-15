//
//  RestaurantMenuResponse.swift
//  smartPOS
//
//  Created by I Am Focused on 01/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation

struct RestaurantMenuResponse: Decodable {
    let statusCode: Int
    let message: String
    let data: RestaurantMenu
}


struct RestaurantMenu: Decodable {
    let menu: Menu
    let menuGroups: MenuGroups
}
typealias MenuGroups = [MenuGroup]
struct MenuGroup: Decodable {
    let id: String
    let name: String
    let menuId: String
    let index: Int
    let menuItems: [MenuItem]
}

