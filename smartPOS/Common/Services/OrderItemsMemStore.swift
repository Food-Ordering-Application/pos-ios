//
//  OrderItemItemsMemStore.swift
//  smartPOS
//
//  Created by I Am Focused on 22/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation

class OrderItemsMemStore: OrderItemsStoreProtocol, OrderItemsStoreUtilityProtocol {
   
 
   
    
    // MARK: - Data
    
    static var orderItems: [OrderItem] = []
  
    
    // MARK: - CRUD operations - Inner closure
  
    func fetchOrderItems(completionHandler: @escaping (() throws -> [OrderItem]) -> Void) {
        completionHandler { type(of: self).orderItems }
    }
  
    func fetchOrderItem(id: String, completionHandler: @escaping (() throws -> OrderItem?) -> Void) {
        if let index = indexOfOrderItemWithID(id: id) {
            completionHandler { type(of: self).orderItems[index] }
        }
        else {
            completionHandler { throw OrderItemsStoreError.CannotFetch("Cannot fetch orderItem with id \(id)") }
        }
    }

    func createOrderItems(orderItemsToCreate: [OrderItem], completionHandler: @escaping (() throws -> [OrderItem]?) -> Void) {
        var orderItems: [OrderItem] = []
        for orderItemToCreate in orderItemsToCreate {
            var orderItem = orderItemToCreate
            generateOrderItemID(orderItem: &orderItem)
            calculateOrderItemTotal(orderItem: &orderItem)
            type(of: self).orderItems.append(orderItem)
            orderItems.append(orderItem)
        }
        completionHandler { orderItems }
    }
    
    func createOrderItem(orderItemToCreate: OrderItem, completionHandler: @escaping (() throws -> OrderItem?) -> Void) {
        var orderItem = orderItemToCreate
        generateOrderItemID(orderItem: &orderItem)
        calculateOrderItemTotal(orderItem: &orderItem)
        type(of: self).orderItems.append(orderItem)
        completionHandler { orderItem }
    }
  
    func updateOrderItem(orderItemToUpdate: OrderItem, completionHandler: @escaping (() throws -> OrderItem?) -> Void) {
        if let index = indexOfOrderItemWithID(id: orderItemToUpdate.id) {
            type(of: self).orderItems[index] = orderItemToUpdate
            let orderItem = type(of: self).orderItems[index]
            completionHandler { orderItem }
        }
        else {
            completionHandler { throw OrderItemsStoreError.CannotUpdate("Cannot fetch orderItem with id \(String(describing: orderItemToUpdate.id)) to update") }
        }
    }
  
    func deleteOrderItem(id: String, completionHandler: @escaping (() throws -> OrderItem?) -> Void) {
        if let index = indexOfOrderItemWithID(id: id) {
            let orderItem = type(of: self).orderItems.remove(at: index)
            completionHandler { orderItem }
        }
        else {
            completionHandler { throw OrderItemsStoreError.CannotDelete("Cannot fetch orderItem with id \(id) to delete") }
        }
    }

    // MARK: - Convenience methods
  
    private func indexOfOrderItemWithID(id: String?) -> Int? {
        return type(of: self).orderItems.firstIndex { return $0.id == id }
    }
}
