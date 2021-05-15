//
//  MenuItem.swift
//  smartPOS
//
//  Created by I Am Focused on 14/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import CoreData
import CoreStore
import Foundation

typealias MenuItems = [MenuItem]
struct MenuItem: Decodable {
    var id: String = ""
    var name: String = "Menu item name"
    var description: String = "Menu item description"
    var price: Double = 100000
    var imageUrl: String = "pizza"
    var index: Float = 1
    var isActive: Bool = true
}

