//
//  ToppingGroup.swift
//  smartPOS
//
//  Created by I Am Focused on 14/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
typealias ToppingGroups = [ToppingGroup]
struct ToppingGroup: Decodable {
    var id: String
    var name: String
//    var index: Float
//    var isActive: Bool?
    var toppingItems: [ToppingItem]
}
