//
//  CSToppingGroup.swift
//  smartPOS
//
//  Created by I Am Focused on 14/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
import CoreStore

final class CSToppingGroup: CoreStoreObject {
    @Field.Stored("id")
    var id: String?
    
    @Field.Stored("name")
    var name: String?
    
    @Field.Stored("index")
    var index: Int?
    
    @Field.Stored("isActive")
    var isActive: Bool?
    
    @Field.Relationship("menuItem")
    var menuItem: CSMenuItem?
    
    @Field.Relationship("toppingItems", inverse: \.$toppingGroup)
    var toppingItems: Set<CSToppingItem>
    
}
