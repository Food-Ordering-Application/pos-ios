//
//  ConfirmOrderResponse.swift
//  smartPOS
//
//  Created by I Am Focused on 29/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation

struct ConfirmOrderResponse: Decodable {
    let statusCode: Int
    let message: String
}
