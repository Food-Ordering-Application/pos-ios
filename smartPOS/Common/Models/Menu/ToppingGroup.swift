//
//  ToppingGroup.swift
//  smartPOS
//
//  Created by I Am Focused on 14/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
typealias ToppingGroups = [ToppingGroup]
struct ToppingGroup: Decodable, Hashable, Equatable {
    var id: String
    var name: String
//    var index: Float
//    var isActive: Bool?
    var toppingItems: [ToppingItem]
    var hashValue: Int { get { return id.hashValue } }
}

func ==(left:ToppingGroup, right:ToppingGroup) -> Bool {
    return left.id == right.id
}
