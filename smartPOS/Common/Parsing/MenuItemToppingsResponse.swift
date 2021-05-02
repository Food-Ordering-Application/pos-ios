//
//  MenuItemToppingsResponse.swift
//  smartPOS
//
//  Created by I Am Focused on 02/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
struct MenuItemToppingsResponse: Decodable {
    let statusCode: Int
    let message: String
    let data: MenuItemToppingsData
}
struct MenuItemToppingsData: Decodable {
    let toppingGroups: [ToppingGroup]
}

