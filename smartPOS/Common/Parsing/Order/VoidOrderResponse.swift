//
//  VoidOrderResponse.swift
//  smartPOS
//
//  Created by IAmFocused on 6/10/21.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
struct VoidOrderResponse: Decodable {
    let statusCode: Int
    let message: String
}
