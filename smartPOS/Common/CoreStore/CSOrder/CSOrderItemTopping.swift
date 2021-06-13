//
//  CSOrderItemTopping.swift
//  smartPOS
//
//  Created by I Am Focused on 14/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import CoreStore
import Foundation
final class CSOrderItemTopping: CoreStoreObject {
    @Field.Stored("id")
    var id: String = CSDatabase.uuid()
    
    @Field.Stored("state")
    var state: String? = OrderItemStatus.instock.rawValue
    
    @Field.Stored("name")
    var name: String?
    
    @Field.Relationship("menuItemTopping")
    var menuItemTopping: CSMenuItemTopping?
    
    @Field.Stored("quantity")
    var quantity: Int? = 1
    
    @Field.Stored("price")
    var price: Double? = 0
    
    @Field.Relationship("orderItem")
    var orderItem: CSOrderItem?
}

extension CSOrderItemTopping {
    func toStruct() -> OrderItemTopping {
//        print("🙏", orderItem, menuItemTopping)
        return OrderItemTopping(id: id, state: state, name: name, toppingItemId: menuItemTopping?.toppingItem?.id, quantity: quantity, price: price)
    }

    func calculateTotal() -> Double {
        return menuItemTopping?.customPrice ?? 0 * Double(quantity ?? 1)
    }
}
