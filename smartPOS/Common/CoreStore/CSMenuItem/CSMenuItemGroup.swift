//
//  CSMenuItemGroup.swift
//  smartPOS
//
//  Created by I Am Focused on 14/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
import CoreStore

final class CSMenuItemGroup: CoreStoreObject {
    
    @Field.Stored("id")
    var id: String = CSDatabase.uuid()
    
    @Field.Stored("name" )
    var name: String = "MenuItem name"
    
    @Field.Stored("index")
    var index: Int = 0

    @Field.Relationship("menu")
    var menu: CSMenu?
    
    @Field.Relationship("menuItems", inverse: \.$menuItemGroup)
    var menuItems: Set<CSMenuItem>
}

extension CSMenuItemGroup {
    func toStruct() -> MenuItemGroup {
        return MenuItemGroup(id: id, name: name, index: index)
    }
}
