//
//  OrderDetailResponse.swift
//  smartPOS
//
//  Created by I Am Focused on 08/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
struct OrderDetailResponse: Decodable {
    let statusCode: Int
    let message: String
    let data: OrderAndOrderItemData
}
