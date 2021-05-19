//
//  CSOrder.swift
//  smartPOS
//
//  Created by I Am Focused on 14/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import CoreStore
import Foundation
import SwiftDate

final class CSOrder: CoreStoreObject {
    @Field.Stored("id", dynamicInitialValue: { UUID().uuidString })
    var id: String?
    
    @Field.Stored("cashierId")
    var cashierId: String?
    
    @Field.Stored("restaurantId")
    var restaurantId: String?
    
    @Field.Stored("subTotal")
    var subTotal: Double = 0
    
    @Field.Stored("itemDiscount")
    var itemDiscount: Float = 0
    
    @Field.Stored("serviceFee")
    var serviceFee: Float = 0
    
    @Field.Stored("discount")
    var discount: Float = 0
    
    @Field.Stored("grandTotal")
    var grandTotal: Double = 0
    
    @Field.Stored("paymentType")
    var paymentType: String = PaymentType.cod.rawValue
    
    @Field.Stored("status")
    var status: String = OrderStatus.draft.rawValue
    
    @Field.Stored("createdAt", dynamicInitialValue: { Date() })
    var createdAt: Date
    
    @Field.Stored("updatedAt", dynamicInitialValue: { Date() })
    var updatedAt: Date
    
    @Field.Relationship("orderItems", inverse: \.$order)
    var orderItems: [CSOrderItem]
    
    @Field.Virtual(
        "dateName",
        customGetter: { object, field in
            if let dateName = field.primitiveValue {
                return dateName
            }
            let dateName: String
            let date = object.$createdAt.value as Date
         

            if date.compare(.isToday) {
                dateName = "Hôm nay"
            } else if  date.compare(.isYesterday) {
                dateName = "Hôm qua"
            } else if  date.compare(.isLastWeek) {
                dateName = "Tuần trước"
            } else {
                dateName = date.toFormat("dd MMM yyyy")
            }
            field.primitiveValue = dateName
            return dateName
        }
    )
    var dateName: String!
    
    @Field.Stored("isSynced")
    var isSynced: Bool = false
    
}

extension CSOrder {
    func toStruct() -> Order {
        return Order(id: id, cashierId: cashierId, restaurantId: restaurantId, subTotal: subTotal, itemDiscount: itemDiscount, serviceFee: serviceFee, discount: discount, grandTotal: grandTotal, paymentType: PaymentType(rawValue: paymentType), status: OrderStatus(rawValue: status), createdAt: createdAt, updatedAt: updatedAt)
    }

    func toDeepStruct() -> NestedOrder {
        return NestedOrder(id: id, status: OrderStatus(rawValue: status), cashierId: cashierId, restaurantId: restaurantId, paymentType: PaymentType(rawValue: paymentType), serviceFee: serviceFee, subTotal: subTotal, grandTotal: grandTotal, itemDiscount: itemDiscount, discount: discount, createdAt: createdAt, updatedAt: updatedAt, orderItems: orderItems.map { (csOrderItem) -> OrderItemRes in csOrderItem.toDeepStruct() }, delivery: nil)
    }

    func calculateTotal() -> Double {
        let orderItemTotal = orderItems.map { (csOrderItem) -> Double in
            csOrderItem.calculateTotal()
        }.reduce(0, +)
        return orderItemTotal
    }
}
