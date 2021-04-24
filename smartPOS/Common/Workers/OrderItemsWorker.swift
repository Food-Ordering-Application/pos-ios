//
//  OrderItemsWorker.swift
//  smartPOS
//
//  Created by I Am Focused on 22/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//
import Foundation

class OrderItemsWorker {
    var orderItemsStore: OrderItemsStoreProtocol

    init(orderItemsStore: OrderItemsStoreProtocol) {
        self.orderItemsStore = orderItemsStore
    }

    func fetchOrderItems(completionHandler: @escaping ([OrderItem]) -> Void) {
        orderItemsStore.fetchOrderItems { (orderItems: () throws -> [OrderItem]) -> Void in
            do {
                let orderItems = try orderItems()
                DispatchQueue.main.async {
                    completionHandler(orderItems)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler([])
                }
            }
        }
    }
    func createOrderItems(orderItemsToCreate: [OrderItem], completionHandler: @escaping ([OrderItem]?) -> Void) {
        orderItemsStore.createOrderItems(orderItemsToCreate: orderItemsToCreate) { (orderItems: () throws -> [OrderItem]?) -> Void in
            do {
                let orderItems = try orderItems()
                DispatchQueue.main.async {
                    completionHandler(orderItems)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }

    func createOrderItem(orderItemToCreate: OrderItem, completionHandler: @escaping (OrderItem?) -> Void) {
        orderItemsStore.createOrderItem(orderItemToCreate: orderItemToCreate) { (orderItem: () throws -> OrderItem?) -> Void in
            do {
                let orderItem = try orderItem()
                DispatchQueue.main.async {
                    completionHandler(orderItem)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }

    func updateOrderItem(orderItemToUpdate: OrderItem, completionHandler: @escaping (OrderItem?) -> Void) {
        orderItemsStore.updateOrderItem(orderItemToUpdate: orderItemToUpdate) { (orderItem: () throws -> OrderItem?) in
            do {
                let orderItem = try orderItem()
                DispatchQueue.main.async {
                    completionHandler(orderItem)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
}

// MARK: - OrderItems store API

protocol OrderItemsStoreProtocol {

    // MARK: CRUD operations - Inner closure

    func fetchOrderItems(completionHandler: @escaping (() throws -> [OrderItem]) -> Void)
    func fetchOrderItem(id: String, completionHandler: @escaping (() throws -> OrderItem?) -> Void)
    func createOrderItems(orderItemsToCreate: [OrderItem], completionHandler: @escaping (() throws -> [OrderItem]?) -> Void)
    func createOrderItem(orderItemToCreate: OrderItem, completionHandler: @escaping (() throws -> OrderItem?) -> Void)
    func updateOrderItem(orderItemToUpdate: OrderItem, completionHandler: @escaping (() throws -> OrderItem?) -> Void)
    func deleteOrderItem(id: String, completionHandler: @escaping (() throws -> OrderItem?) -> Void)
}

protocol OrderItemsStoreUtilityProtocol {}

extension OrderItemsStoreUtilityProtocol {
    func generateOrderItemID(orderItem: inout OrderItem) {
        guard orderItem.id == nil else { return }
        orderItem.id = "\(arc4random())"
    }

    func calculateOrderItemTotal(orderItem: inout OrderItem) {
//    guard orderItem.grandTotal == NSDecimalNumber.notANumber else { return }
//    orderItem.grandTotal = Int32(truncating: NSDecimalNumber.one)
    }
}

 
struct OrderAndOrderItems {
    var order: Order?
    var orderItems: [OrderItem]
}

enum OrderItemsStoreResult<U> {
    case Success(result: U)
    case Failure(error: OrderItemsStoreError)
}

// MARK: - OrderItems store CRUD operation errors

enum OrderItemsStoreError: Equatable, Error {
    case CannotFetch(String)
    case CannotCreate(String)
    case CannotUpdate(String)
    case CannotDelete(String)
}

func ==(lhs: OrderItemsStoreError, rhs: OrderItemsStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    case (.CannotCreate(let a), .CannotCreate(let b)) where a == b: return true
    case (.CannotUpdate(let a), .CannotUpdate(let b)) where a == b: return true
    case (.CannotDelete(let a), .CannotDelete(let b)) where a == b: return true
    default: return false
    }
}