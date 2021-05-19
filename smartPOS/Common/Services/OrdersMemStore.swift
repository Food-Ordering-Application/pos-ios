//
//  OrdersMemStore.swift
//  smartPOS
//
//  Created by Raymond Law on 2/12/19.
//  Copyright © 2019 Clean Swift LLC. All rights reserved.
//

import CoreStore
import Foundation

class OrdersMemStore: OrdersStoreProtocol, OrdersStoreUtilityProtocol {
    // MARK: - Data
  
    static var orders: [Order] = []
    
    // MARK: - CRUD operations - Inner closure
  
    func fetchOrders(completionHandler: @escaping (() throws -> [Order]) -> Void) {
        completionHandler { type(of: self).orders }
    }
  
    func fetchOrder(id: String, completionHandler: @escaping (() throws -> Order?) -> Void) {
        if let index = indexOfOrderWithID(id: id) {
            completionHandler { type(of: self).orders[index] }
        }
        else {
            completionHandler { throw OrdersStoreError.CannotFetch("Cannot fetch order with id \(id)") }
        }
    }
    
    func createOrderAndOrderItem(orderItemFormFields: Checkout.OrderItemFormFields, completionHandler: @escaping (() throws -> OrderAndOrderItemData?) -> Void) {
//        print("😉 😉 createOrderAndOrderItem 😉 😉")
//        print(orderItemFormFields)
//        print("---------------------------------------")
        var orderId: String?
        _ = try? CSDatabase.stack.perform(
            asynchronous: { transaction in
                let csOrder = transaction.create(Into<CSOrder>())
                orderId = csOrder.id
                var subTotal = csOrder.subTotal
                let csOrderItem = transaction.create(Into<CSOrderItem>())
                let orderItemId = csOrderItem.id
                csOrderItem.order = try transaction.fetchOne(From<CSOrder>().where(\.$id == orderId))
                csOrderItem.menuItem = try transaction.fetchOne(From<CSMenuItem>().where(\.$id == orderItemFormFields.menuItemId))
                csOrderItem.name = orderItemFormFields.name
                csOrderItem.price = orderItemFormFields.price
                csOrderItem.quantity = orderItemFormFields.quantity
                /// Caculated total Order
                var toppingPrice: Double = 0
                for orderItemTopping in orderItemFormFields.orderItemToppings {
                    let csOrderItemTopping = transaction.create(Into<CSOrderItemTopping>())
                    csOrderItemTopping.orderItem = try transaction.fetchOne(From<CSOrderItem>().where(\.$id == orderItemId))
                    csOrderItemTopping.menuItemTopping = try transaction.fetchOne(From<CSMenuItemTopping>().where(\.$id == orderItemTopping.menuItemToppingId))
                    csOrderItemTopping.name = orderItemTopping.name
                    csOrderItemTopping.price = orderItemTopping.price
                    csOrderItemTopping.quantity = orderItemTopping.quantity
                    
                    /// Caculated total Order
                    toppingPrice += csOrderItemTopping.price ?? 0 * Double(csOrderItemTopping.quantity ?? 1)
                }
                csOrderItem.orderItemToppings = try transaction.fetchAll(From<CSOrderItemTopping>().where(\.$orderItem ~ \.$id == orderItemId))
                /// Caculated total Order
                csOrderItem.price = (csOrderItem.price ?? 0 + toppingPrice) * Double(csOrderItem.quantity ?? 1)
                subTotal += csOrderItem.price ?? 0
                /// Caculated total Order
                csOrder.subTotal = subTotal
                csOrder.grandTotal = subTotal

            },
            completion: { (result) -> Void in
                switch result {
                case .success:
                    print("success!")
                    if let nestedOrder: CSOrder = try! CSDatabase.stack.fetchOne(From<CSOrder>().where(\.$id == orderId)) {
                        print("🆑 ------------------- ")
                        print(nestedOrder.toDeepStruct())
                        print("🆑 ------------------- ")
                        completionHandler {
                            OrderAndOrderItemData(order: nestedOrder.toDeepStruct())
                        }
                    }
                    else {
                        completionHandler {
                            throw OrdersStoreError.CannotFetch("Cannot create order from Local - Parsing")
                        }
                    }
                    
                case .failure(let error):
                    completionHandler {
                        throw OrdersStoreError.CannotFetch("Cannot create order from Local: \(error)")
                    }
                }
            }
        )
    }
  
    func createOrderItem(orderId: String?, orderItemFormFields: Checkout.OrderItemFormFields, completionHandler: @escaping (() throws -> OrderAndOrderItemData?) -> Void) {
        guard let orderId = orderId else {
            completionHandler {
                throw OrdersStoreError.CannotFetch("Cannot found orderId")
            }
            return
        }
        _ = try CSDatabase.stack.perform(
            asynchronous: { transaction in
                let csOrder = try! transaction.fetchOne(From<CSOrder>().where(\.$id == orderId))
                var subTotal = csOrder?.subTotal ?? 0
                let csOrderItem = transaction.create(Into<CSOrderItem>())
                let orderItemId = csOrderItem.id
                csOrderItem.order = try transaction.fetchOne(From<CSOrder>().where(\.$id == orderId))
                csOrderItem.menuItem = try transaction.fetchOne(From<CSMenuItem>().where(\.$id == orderItemFormFields.menuItemId))
                csOrderItem.name = orderItemFormFields.name
                csOrderItem.price = orderItemFormFields.price
                csOrderItem.quantity = orderItemFormFields.quantity
                var toppingPrice: Double = 0
                for orderItemTopping in orderItemFormFields.orderItemToppings {
                    let csOrderItemTopping = transaction.create(Into<CSOrderItemTopping>())
                    csOrderItemTopping.orderItem = try transaction.fetchOne(From<CSOrderItem>().where(\.$id == orderItemId))
                    csOrderItemTopping.menuItemTopping = try transaction.fetchOne(From<CSMenuItemTopping>().where(\.$id == orderItemTopping.menuItemToppingId))
                    csOrderItemTopping.name = orderItemTopping.name
                    csOrderItemTopping.price = orderItemTopping.price
                    csOrderItemTopping.quantity = orderItemTopping.quantity
                    /// Caculated total Order
                    toppingPrice += csOrderItemTopping.price ?? 0 * Double(csOrderItemTopping.quantity ?? 1)
                }
                csOrderItem.orderItemToppings = try transaction.fetchAll(From<CSOrderItemTopping>().where(\.$orderItem ~ \.$id == orderItemId))
                /// Caculated total Order
                csOrderItem.price = (csOrderItem.price ?? 0 + toppingPrice) * Double(csOrderItem.quantity ?? 1)
                subTotal += csOrderItem.price ?? 0
                /// Caculated total Order
                csOrder?.subTotal = subTotal
                csOrder?.grandTotal = subTotal
            },
            success: { _ in
                if let nestedOrder: CSOrder = try! CSDatabase.stack.fetchOne(From<CSOrder>().where(\.$id == orderId)) {
//                    print("🆑 ------------------- ")
//                    print(nestedOrder.toDeepStruct())
//                    print("🆑 ------------------- ")
                    completionHandler {
                        OrderAndOrderItemData(order: nestedOrder.toDeepStruct())
                    }
                }
                else {
                    completionHandler {
                        throw OrdersStoreError.CannotUpdate("Cannot create order from Local - Parsing")
                    }
                }
            },
            failure: { coreStoreError in
                completionHandler {
                    throw OrdersStoreError.CannotUpdate("Cannot create order from Local: \(coreStoreError.localizedDescription)")
                }
            }
        )
    }

    func manipulateOrderItem(handle: ManipulateOrderItemModel, orderItemToUpdate: OrderItem?, completionHandler: @escaping (() throws -> OrderAndOrderItemData?) -> Void) {
        let orderId = handle.orderId
        let orderItemId = handle.orderItemId
        let action = handle.action
        
        if orderId == "" || orderItemId == "" {
            completionHandler {
                throw OrdersStoreError.CannotFetch("Something went wrong.")
            }
            return
        }
        _ = try CSDatabase.stack.perform(
            asynchronous: { transaction in
                let csOrder = try! transaction.fetchOne(From<CSOrder>().where(\.$id == orderId))
                let csOrderItem = try! transaction.fetchOne(From<CSOrderItem>().where(\.$id == orderItemId))
                switch action {
                case .remove:
                    print("remove")
                    transaction.delete(csOrderItem)
                     
                case .increase, .reduce:
                    print(action)
                    let curOrderItemQuantity = csOrderItem?.quantity ?? 1
                    csOrderItem?.quantity = action == .increase ? curOrderItemQuantity + 1 : curOrderItemQuantity - 1
                }
                
                /// If remove all orderIten in order  then delete that order
                if csOrder?.toDeepStruct().orderItems?.count == 0 {
                    transaction.delete(csOrder)
                    return
                }
                /// Just calling if have orderItem in order
                let total = csOrder?.calculateTotal()
                csOrder?.subTotal = total ?? 0
                csOrder?.grandTotal = total ?? 0
        
            },
            success: { _ in
                if let nestedOrder: CSOrder = try! CSDatabase.stack.fetchOne(From<CSOrder>().where(\.$id == orderId)) {
                    completionHandler {
                        OrderAndOrderItemData(order: nestedOrder.toDeepStruct())
                    }
                }
                else {
                    completionHandler {
                        throw OrdersStoreError.CannotUpdate("Cannot \(action.rawValue) orderItem from Local - Parsing")
                    }
                }
            },
            failure: { coreStoreError in
                completionHandler {
                    throw OrdersStoreError.CannotUpdate("Cannot \(action.rawValue) orderItem from Local: \(coreStoreError.localizedDescription)")
                }
            }
        )
    }
    
    func createOrder(orderToCreate: Order, completionHandler: @escaping (() throws -> Order?) -> Void) {
        var order = orderToCreate
        generateOrderID(order: &order)
//        calculateOrderTotal(order: &order)
        type(of: self).orders.append(order)
        completionHandler { order }
    }
  
    func updateOrder(orderToUpdate: Order, completionHandler: @escaping (() throws -> OrderAndOrderItemData?) -> Void) {
        guard let orderId = orderToUpdate.id else {
            completionHandler {
                throw OrdersStoreError.CannotFetch("Something went wrong.")
            }
            return
        }
        _ = try CSDatabase.stack.perform(
            asynchronous: { transaction in
                let csOrder = try! transaction.fetchOne(From<CSOrder>().where(\.$id == orderId))
                csOrder?.status = orderToUpdate.status!.rawValue
            },
            success: { _ in
                if let nestedOrder: CSOrder = try! CSDatabase.stack.fetchOne(From<CSOrder>().where(\.$id == orderId)) {
                    completionHandler {
                        OrderAndOrderItemData(order: nestedOrder.toDeepStruct())
                    }
                }
                else {
                    completionHandler {
                        throw OrdersStoreError.CannotUpdate("Cannot place order from Local - Parsing")
                    }
                }
            },
            failure: { coreStoreError in
                completionHandler { throw OrdersStoreError.CannotUpdate("Cannot fetch order with id \(coreStoreError.localizedDescription) to update") }
            }
        )
    }
  
    func deleteOrder(id: String, completionHandler: @escaping (() throws -> OrderAndOrderItemData?) -> Void) {
        if id == "" {
            completionHandler {
                throw OrdersStoreError.CannotFetch("Something went wrong.")
            }
            return
        }
        _ = try CSDatabase.stack.perform(
            asynchronous: { transaction in
                let csOrder = try! transaction.fetchOne(From<CSOrder>().where(\.$id == id))
                _ = csOrder?.orderItems.map { (csOrderItem) -> Void in
                    csOrderItem.orderItemToppings.map { (csOrderItemTopping) -> Void in
                        transaction.delete(csOrderItemTopping)
                    }
                    transaction.delete(csOrderItem)
                }
                transaction.delete(csOrder)
            },
            success: { _ in
                completionHandler {
                    OrderAndOrderItemData(order: nil)
                }
            },
            failure: { coreStoreError in
                completionHandler {
                    throw OrdersStoreError.CannotUpdate("Cannot delete order from Local: \(coreStoreError.localizedDescription)")
                }
            }
        )
    }

    // MARK: - Convenience methods
  
    private func indexOfOrderWithID(id: String?) -> Int? {
        return type(of: self).orders.firstIndex { return $0.id == id }
    }
}
