//
//  OrderItemErrors.swift
//  smartPOS
//
//  Created by I Am Focused on 22/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation

enum OrderItemErrors: Error {
    case couldNotLoadOrderItems(error: String)
    case couldNotLoadOrderItemDetail(error: String)
    case couldNotLoadCreateOrder(error: String)
}
