//
//  CreateOrderItemResponse.swift
//  smartPOS
//
//  Created by I Am Focused on 02/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation

struct CreateOrderItemResponse: Decodable {
    let statusCode: Int
    let message: String
    let data: OrderAndOrderItemData
}
