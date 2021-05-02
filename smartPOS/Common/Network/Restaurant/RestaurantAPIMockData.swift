//
//  RestaurantAPIMockData.swift
//  smartPOS
//
//  Created by I Am Focused on 25/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation

extension RestaurantAPI {
    var sampleData: Data {
        switch self {
        case .getMenu:
            return stubbedResponse("Menu")
        case .getMenuItemToppings:
            return stubbedResponse("MenuItemToppings")
        }
    }
}
