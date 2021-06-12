//
//  MenuItemResponse.swift
//  smartPOS
//
//  Created by IAmFocused on 6/12/21.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
struct MenuItemResponse: Decodable {
    let statusCode: Int
    let message: String
}
