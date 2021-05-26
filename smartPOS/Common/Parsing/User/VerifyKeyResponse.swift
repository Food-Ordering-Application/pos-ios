//
//  VerifyKeyResponse.swift
//  smartPOS
//
//  Created by I Am Focused on 23/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation

struct VerifyKeyResponse: Decodable {
    let statusCode: Int
    let message: String
    let data: VerifyData
}


struct VerifyData: Decodable {
    let restaurantId: String
    let merchantId: String
}
