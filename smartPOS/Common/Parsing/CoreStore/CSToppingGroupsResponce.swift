//
//  CSToppingGroupsResponce.swift
//  smartPOS
//
//  Created by I Am Focused on 16/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation

struct CSToppingGroupsResponce: Decodable {
    let statusCode: Int
    let message: String
    let data: CSToppingGroupsData?
}


struct CSToppingGroupsData: Decodable {
    let results: ToppingGroupResults
}

typealias ToppingGroupResults = [ToppingGroupData]
struct ToppingGroupData: Decodable {
    var id: String
    var name: String
    var index: Float
    var isActive: Bool?
}

