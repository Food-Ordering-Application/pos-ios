//
//  MenuItem.swift
//  smartPOS
//
//  Created by I Am Focused on 14/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation

struct MenuItem {
    var id: String = "MenuItemID"
    var menu: Menu = Menu(id: "MenuID", restaurent: Restaurant(id: "RestaurantID", merchant: Merchant(id: "MerchantID", name: "Merchant Smart"), name: "RestaurantName" , imageUrl: "pizza", videoUrl: "pizza", numRate: 10, rating: 4.5, area: "", isActive: true), name: "Pizza", index: 1)
    var name: String = "MenuItem"
    var description: String = "Menu item description"
    var price: Double = 100000
    var imageUrl: String = "pizza"
    var numLikes: Int = 10
    var index: Float = 1
    var isActive: Bool = true
}
