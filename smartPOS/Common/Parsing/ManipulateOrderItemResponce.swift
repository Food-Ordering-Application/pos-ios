//
//  ReduceOrIncreaseOrderItemResponce.swift
//  smartPOS
//
//  Created by I Am Focused on 02/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation

enum ManipulateOrderItemRequest: String {
    case increase = "increase-ordItem-quantity"
    case reduce = "reduce-ordItem-quantity"
    case remove = "remove-ordItem"
}

struct ManipulateOrderItemResponce: Decodable {
    let statusCode: Int
    let message: String
    let data: OrderAndOrderItemData
}
