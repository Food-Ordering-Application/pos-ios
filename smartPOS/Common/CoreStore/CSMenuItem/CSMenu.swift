//
//  CSMenu.swift
//  smartPOS
//
//  Created by I Am Focused on 14/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
import CoreStore

final class CSMenu: CoreStoreObject {

    @Field.Stored("id")
    var id: String = CSDatabase.uuid()
    
    @Field.Stored("name")
    var name: String = "Menu name"
    
//    @Field.Stored("index")
//    var index: Int = 0

    @Field.Relationship("menuItemGroups", inverse: \.$menu )
    var menuItemGroups: Set<CSMenuItemGroup>
    
}


extension CSMenu {
    func toStruct() -> Menu {
        return Menu(id: id, name: name)
    }
}
