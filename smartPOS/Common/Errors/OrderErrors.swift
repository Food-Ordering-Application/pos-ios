//
//  OrderError.swift
//  smartPOS
//
//  Created by I Am Focused on 17/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation

enum OrderErrors: Error {
    case couldNotLoadOrders(error: String)
    case couldNotLoadOrderDetail(error: String)
}
