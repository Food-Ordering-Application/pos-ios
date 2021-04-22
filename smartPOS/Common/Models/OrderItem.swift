//
//  File.swift
//  smartPOS
//
//  Created by I Am Focused on 17/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
struct OrderItem {
    var id: String?
    var menuItemId: String
    var orderId: String
    var price: Double
    var discount: Float
    var quantity: Int
    var note: String
}
