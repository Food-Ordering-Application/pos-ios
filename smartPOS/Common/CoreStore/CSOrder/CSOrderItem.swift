//
//  CSOrderItem.swift
//  smartPOS
//
//  Created by I Am Focused on 14/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import CoreStore
import Foundation
final class CSOrderItem: CoreStoreObject {
    @Field.Stored("id")
    var id: String = CSDatabase.uuid()
    
    @Field.Relationship("menuItem")
    var menuItem: CSMenuItem?
    
    @Field.Stored("name")
    var name: String?
    
    @Field.Stored("state")
    var state: String = OrderItemStatus.instock.rawValue
    
    @Field.Relationship("order")
    var order: CSOrder?
    
    @Field.Stored("price")
    var price: Double? = 0
    
    @Field.Stored("subTotal")
    var subTotal: Double? = 0
    
    @Field.Stored("discount")
    var discount: Float? = 0
    
    @Field.Stored("quantity")
    var quantity: Int? = 1
    
    @Field.Stored("note")
    var note: String? = ""
    
    @Field.Relationship("orderItemToppings", inverse: \.$orderItem)
    var orderItemToppings: [CSOrderItemTopping]
}

extension CSOrderItem {
    func toDeepStruct() -> OrderItemRes {
        return OrderItemRes(id: id, menuItemId: menuItem?.id, menuItemImageUrl:menuItem?.imageUrl ,orderId: order?.id, price: price, name: name, discount: discount, subTotal: subTotal, quantity: quantity, state: OrderItemStatus(rawValue: state), orderItemToppings: orderItemToppings.map { (csOrderItemTopping) -> OrderItemTopping in
            csOrderItemTopping.toStruct()
        })
    }

    func toStruct() -> OrderItem {
        return OrderItem(id: id, menuItemId: menuItem?.id,menuItemImageUrl: menuItem?.imageUrl, name: name, orderId: order?.id, price: price, discount: discount, subTotal: subTotal, state: OrderItemStatus(rawValue: state), quantity: quantity, note: note)
    }
    
    func calculateTotal() -> Double {
        let toppingTotal = orderItemToppings.map { (csOrderItemTopping) -> Double in
            csOrderItemTopping.calculateTotal()
        }.reduce(0, +)
        return (menuItem?.price ?? 0 + toppingTotal) * Double(quantity ?? 1)
    }
}
