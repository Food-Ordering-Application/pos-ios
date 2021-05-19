//
//  OrdersWorker.swift
//  smartPOS
//
//  Created by Raymond Law on 2/12/19.
//  Copyright © 2019 Clean Swift LLC. All rights reserved.
//

import Foundation

class OrdersWorker {
    var ordersStore: OrdersStoreProtocol

    init(ordersStore: OrdersStoreProtocol) {
        self.ordersStore = ordersStore
    }

    func fetchOrders(completionHandler: @escaping ([Order]) -> Void) {
        ordersStore.fetchOrders { (orders: () throws -> [Order]) -> Void in
            do {
                let orders = try orders()
                DispatchQueue.main.async {
                    completionHandler(orders)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler([])
                }
            }
        }
    }

    func createOrderAndOrderItem(orderItemFormFields: Checkout.OrderItemFormFields, completionHandler: @escaping (OrderAndOrderItemData?) -> Void) {
        ordersStore.createOrderAndOrderItem(orderItemFormFields: orderItemFormFields) { (orderAndOrderItemData: () throws -> OrderAndOrderItemData?) -> Void in
            do {
                let nestedOrder = try orderAndOrderItemData()
                DispatchQueue.main.async {
                    completionHandler(nestedOrder)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }

    func createOrderItem(orderId: String?, orderItemFormFields: Checkout.OrderItemFormFields, completionHandler: @escaping (OrderAndOrderItemData?) -> Void) {
        ordersStore.createOrderItem(orderId: orderId, orderItemFormFields: orderItemFormFields) { (orderAndOrderItemData: () throws -> OrderAndOrderItemData?) -> Void in
            do {
                let nestedOrder = try orderAndOrderItemData()
                DispatchQueue.main.async {
                    completionHandler(nestedOrder)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }

    func manipulateOrderItem(handle: ManipulateOrderItemModel, orderItemToUpdate: OrderItem?, completionHandler: @escaping (OrderAndOrderItemData?) -> Void) {
        ordersStore.manipulateOrderItem(handle: handle, orderItemToUpdate: orderItemToUpdate) { (orderAndOrderItemData: () throws -> OrderAndOrderItemData?) -> Void in
            do {
                let nestedOrder = try orderAndOrderItemData()
                DispatchQueue.main.async {
                    completionHandler(nestedOrder)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }

    func createOrder(orderToCreate: Order, completionHandler: @escaping (Order?) -> Void) {
        ordersStore.createOrder(orderToCreate: orderToCreate) { (order: () throws -> Order?) -> Void in
            do {
                let order = try order()
                DispatchQueue.main.async {
                    completionHandler(order)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }

    func updateOrder(orderToUpdate: Order, completionHandler: @escaping (Order?) -> Void) {
        ordersStore.updateOrder(orderToUpdate: orderToUpdate) { (order: () throws -> Order?) in
            do {
                let order = try order()
                DispatchQueue.main.async {
                    completionHandler(order)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }

    func deleteOrder(orderId: String, completionHandler: @escaping (OrderAndOrderItemData?) -> Void) {
        ordersStore.deleteOrder(id: orderId) { (orderAndOrderItemData: () throws -> OrderAndOrderItemData?) -> Void in
            do {
                let nestedOrder = try orderAndOrderItemData()
                DispatchQueue.main.async {
                    completionHandler(nestedOrder)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
}

// MARK: - Orders store API

protocol OrdersStoreProtocol {
    // MARK: CRUD operations - Inner closure

    func fetchOrders(completionHandler: @escaping (() throws -> [Order]) -> Void)
    func fetchOrder(id: String, completionHandler: @escaping (() throws -> Order?) -> Void)
    func createOrder(orderToCreate: Order, completionHandler: @escaping (() throws -> Order?) -> Void)
    func updateOrder(orderToUpdate: Order, completionHandler: @escaping (() throws -> Order?) -> Void)

    func deleteOrder(id: String, completionHandler: @escaping (() throws -> OrderAndOrderItemData?) -> Void)

    func createOrderAndOrderItem(orderItemFormFields: Checkout.OrderItemFormFields, completionHandler: @escaping (() throws -> OrderAndOrderItemData?) -> Void)

    func createOrderItem(orderId: String?, orderItemFormFields: Checkout.OrderItemFormFields, completionHandler: @escaping (() throws -> OrderAndOrderItemData?) -> Void)

    func manipulateOrderItem(handle: ManipulateOrderItemModel, orderItemToUpdate: OrderItem?, completionHandler: @escaping (() throws -> OrderAndOrderItemData?) -> Void)
}

protocol OrdersStoreUtilityProtocol {}

extension OrdersStoreUtilityProtocol {
    func generateOrderID(order: inout Order) {
        guard order.id == nil else { return }
        order.id = UUID().uuidString
    }

//    func calculateOrderTotal(order: inout Order) {
//        guard order.grandTotal as NSObject == NSDecimalNumber.notANumber else { return }
//        order.grandTotal = Double(truncating: NSDecimalNumber.one)
//    }
}

// MARK: - Orders store CRUD operation results

typealias OrdersStoreFetchOrdersCompletionHandler = (OrdersStoreResult<[Order]>) -> Void
typealias OrdersStoreFetchOrderCompletionHandler = (OrdersStoreResult<Order>) -> Void
typealias OrdersStoreCreateOrderCompletionHandler = (OrdersStoreResult<Order>) -> Void
typealias OrdersStoreUpdateOrderCompletionHandler = (OrdersStoreResult<Order>) -> Void
typealias OrdersStoreDeleteOrderCompletionHandler = (OrdersStoreResult<Order>) -> Void

enum OrdersStoreResult<U> {
    case Success(result: U)
    case Failure(error: OrdersStoreError)
}

// MARK: - Orders store CRUD operation errors

enum OrdersStoreError: Equatable, Error {
    case CannotFetch(String)
    case CannotCreate(String)
    case CannotUpdate(String)
    case CannotDelete(String)
}

//
// func ==(lhs: OrdersStoreError, rhs: OrdersStoreError) -> Bool {
//  switch (lhs, rhs) {
//  case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
//  case (.CannotCreate(let a), .CannotCreate(let b)) where a == b: return true
//  case (.CannotUpdate(let a), .CannotUpdate(let b)) where a == b: return true
//  case (.CannotDelete(let a), .CannotDelete(let b)) where a == b: return true
//  default: return false
//  }
// }
