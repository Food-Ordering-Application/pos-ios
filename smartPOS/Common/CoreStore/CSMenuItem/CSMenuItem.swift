//
//  CSMenuItem.swift
//  smartPOS
//
//  Created by I Am Focused on 14/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
import CoreStore

final class CSMenuItem: CoreStoreObject {
    @Field.Stored("id")
    var id: String = CSDatabase.uuid()
    
    @Field.Stored("name")
    var name: String = "Menu item name"
    
    @Field.Stored("_description")
    var description: String = "Menu item description"
    
    @Field.Stored("price")
    var price: Double = 0
    
    @Field.Stored("imageUrl")
    var imageUrl: String = ""
    
//    @Field.Stored("index")
//    var index: Float = 1
    
    @Field.Stored("isActive")
    var isActive: Bool = true
   
    @Field.Relationship("menuItemGroup")
    var menuItemGroup: CSMenuItemGroup?
    
    @Field.Relationship("toppingGroups", inverse: \.$menuItem)
    var toppingGroups: Set<CSToppingGroup>
}

extension CSMenuItem {
    func toStruct() -> MenuItem {
        return MenuItem(id: id, name: name, description: description, price: price, imageUrl: imageUrl, isActive: isActive)
    }
}
