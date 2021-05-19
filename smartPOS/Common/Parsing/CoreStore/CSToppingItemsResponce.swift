//
//  CSToppingItemsResponce.swift
//  smartPOS
//
//  Created by I Am Focused on 16/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation

struct CSToppingItemsResponce: Decodable {
    let statusCode: Int
    let message: String
    let data: CSToppingItemsData?
}


struct CSToppingItemsData: Decodable {
    let results: ToppingItemResults
}
typealias ToppingItemResults = [ToppingItemData]
struct ToppingItemData : Decodable {
    var id: String
    var name: String
    var description: String
    var price: Double
    var maxQuantity: Int
    var index: Float
    var isActive: Bool
    var toppingGroupId: String
}

