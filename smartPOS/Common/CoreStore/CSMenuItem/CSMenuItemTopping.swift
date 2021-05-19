//
//  CSMenuItemTopping.swift
//  smartPOS
//
//  Created by I Am Focused on 14/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
import CoreStore

final class CSMenuItemTopping: CoreStoreObject {
    @Field.Stored("id")
    var id: String?
    
    @Field.Stored("customPrice")
    var customPrice: Double?
    
    @Field.Relationship("menuItem")
    var menuItem: CSMenuItem?
    
    @Field.Relationship("toppingItem")
    var toppingItem: CSToppingItem?
    
    @Field.Relationship("orderItemTopping", inverse: \.$menuItemTopping)
    var orderItemTopping: Optional<CSOrderItemTopping>
}

extension CSMenuItemTopping {
    func toStruct() -> MenuItemTopping {
        return MenuItemTopping(id: id ?? "", customPrice: customPrice ?? 0)
    }
}
