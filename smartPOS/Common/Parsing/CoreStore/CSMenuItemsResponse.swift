//
//  CSMenuItemsResponse.swift
//  smartPOS
//
//  Created by IAmFocused on 6/11/21.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
struct CSMenuItemsResponse: Decodable {
    let statusCode: Int
    let message: String
    let data: CSMenuItemsData?
}


struct CSMenuItemsData: Decodable {
    let results: MenuItemResults
}
typealias MenuItemResults = [MenuItemData]
struct MenuItemData : Decodable {
    var id: String
    var name: String
    var description: String
    var price: Double
    var maxQuantity: Int
    var index: Float
    var isActive: Bool
    var toppingGroupId: String
}
