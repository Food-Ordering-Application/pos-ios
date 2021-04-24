//
//  CheckoutInteractor.swift
//  smartPOS
//
//  Created by I Am Focused on 18/04/2021.
//  Copyright (c) 2021 Clean Swift LLC. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol CheckoutBusinessLogic {
    func fetchMenuItems(request: Checkout.FetchMenuItems.Request)
    func createOrderItem(request: Checkout.CreateOrderItem.Request)
    func createOrderAndOrderItems(request: Checkout.CreateOrderAndOrderItems.Request)
}

protocol CheckoutDataStore {
    var menuItems: [MenuItem]? { get }
    var orderItems: [OrderItem]? { get set}
    var order: Order? { get set }
}

class CheckoutInteractor: CheckoutBusinessLogic, CheckoutDataStore {
    
    
    var order: Order?
    var menuItems: [MenuItem]?
    var orderItems: [OrderItem]?
    var presenter: CheckoutPresentationLogic?
    //  var worker: CheckoutWorker? = CheckoutWorker()
    var menuItemsWorker: MenuItemsWorker? = MenuItemsWorker(menuItemsStore: MenuItemsMemStore())
    var ordersWorker: OrdersWorker? = OrdersWorker(ordersStore: OrdersMemStore())
    var orderItemsWorker: OrderItemsWorker? = OrderItemsWorker(orderItemsStore: OrderItemsMemStore())
  
    // MARK: Fetch MenuItems
  
    func fetchMenuItems(request: Checkout.FetchMenuItems.Request) {
        menuItemsWorker?.fetchMenuItems { (menuItems) -> Void in
            self.menuItems = menuItems
            let response = Checkout.FetchMenuItems.Response(menuItems: menuItems)
            self.presenter?.presentFetchedOrder(response: response)
        }
    }
    
    func createOrderItem(request: Checkout.CreateOrderItem.Request) {
        let orderItem  = buildOrderItemFromOrderItemFormFields(request.orderItemFormFields)
        orderItemsWorker?.createOrderItem(orderItemToCreate: orderItem) { (orderItem) -> Void in
            // MARK: ALERT ALERT Please Recheck this line when CRUD OrderItem
            self.orderItems?.append(orderItem!)
            let response = Checkout.CreateOrderItem.Response(orderItem: orderItem)
            self.presenter?.presentCreatedOrderItem(response: response)
        }
    }
    func createOrderAndOrderItems(request: Checkout.CreateOrderAndOrderItems.Request) {
        
        
        let order = Order(id: "ORDER-HAHA-123", customerId: "CUS-123", driverId: "DRI-123", subTotal: 100, itemDiscount: 0.0, shippingFee: 12.0, serviceFee: 2.0, promotionId: "PRO-ID", discount: 1.0, grandTotal: 20000, customerAddressId: "CUS-ADD-123", paymentMode: .cod, paymentType: .cod, status: .checking, note: "ORDER NOTED", createdAt: Date(), deliveredAt: Date(), updatedAt: Date())
        var orderItems: [OrderItem] = []
        ordersWorker?.createOrder(orderToCreate: order) {(order) in
            let orderId = order!.id
            for orderItemFormFields in request.orderItemsFormFields {
                var orderItem = self.buildOrderItemFromOrderItemFormFields(orderItemFormFields)
                orderItem.orderId = orderId!
                orderItems.append(orderItem)
            }
            self.orderItemsWorker?.createOrderItems(orderItemsToCreate: orderItems, completionHandler: { (orderItems) in
                self.orderItems  = orderItems
                let response = Checkout.CreateOrderAndOrderItems.Response(order: order, orderItems: orderItems, error: nil)
                self.presenter?.presentCreateOrderAndOrderItem(response: response)
            })
        }
    }
}

// MARK: - Helper function

extension CheckoutInteractor {
    
    private func buildOrderItemFromOrderItemFormFields(_ orderItemFormFields: Checkout.OrderItemFormFields) -> OrderItem {
        return OrderItem(id: orderItemFormFields.id, menuItemId: orderItemFormFields.menuItemId, orderId: orderItemFormFields.orderId, price: orderItemFormFields.price, discount: 0.0, quantity: orderItemFormFields.quantity, note: "buildOrderItemFromOrderItemFormFields")
    }
}