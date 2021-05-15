//
//  Menu.swift
//  smartPOS
//
//  Created by I Am Focused on 14/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
struct Menu: Codable {
    var id: String
    var name: String
    var index: Int
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case index
    }
}


