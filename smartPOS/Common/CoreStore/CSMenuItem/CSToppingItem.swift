//
//  CSToppingItem.swift
//  smartPOS
//
//  Created by I Am Focused on 14/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
import CoreStore
final class CSToppingItem: CoreStoreObject {
    
    @Field.Stored("id")
    var id: String?
    
    @Field.Stored("name")
    var name: String?
    
    @Field.Stored("_description")
    var description: String?
    
    @Field.Stored("price")
    var price: Double?
    
    @Field.Stored("maxQuantity")
    var maxQuantity: Int?
    
    @Field.Stored("state")
    var state: String = ItemState.instock.rawValue
//    @Field.Stored("index")
//    var index: Float?
    
    @Field.Stored("isActive")
    var isActive: Bool?
    
    @Field.Relationship("topingGroup")
    var toppingGroup: CSToppingGroup?
    
    @Field.Relationship("menuItemToppings", inverse: \.$toppingItem)
    var menuItemToppings: Array<CSMenuItemTopping>
}


extension CSToppingItem {
    func toStruct() -> ToppingItem {
        return ToppingItem(id: id ?? "", name: name ?? "No name", description: description ?? "", price: price ?? 0, maxQuantity: maxQuantity ?? 1, state: ItemState(rawValue: state))
    }
}
