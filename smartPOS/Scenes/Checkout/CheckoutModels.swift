//
//  CheckoutModels.swift
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

enum Checkout {
    // MARK: MenuItems

    struct DisplayedMenuItemGroup {
        var id: String
        var name: String?
        var index: Int?
        var menuItems: [MenuItem]
    }

    enum FetchMenuItems {
        struct Request {
            var restaurantId: String
        }

        struct Response {
            var menu: Menu?
            var menuGroups: [MenuGroup]?
            var error: MenuItemErrors?
        }

        struct ViewModel {
            var displayedMenuItemGroups: [DisplayedMenuItemGroup]
            var error: MenuItemErrors?
        }
    }

    
    enum SearchMenuItems {
        struct Request {
            var keyword: String
        }

        struct Response {
            var menu: Menu?
            var menuGroups: [MenuGroup]?
            var error: MenuItemErrors?
        }

        struct ViewModel {
            var displayedMenuItemGroups: [DisplayedMenuItemGroup]
            var error: MenuItemErrors?
        }
    }

    // MARK: MenuItemToppings
    
    
    enum FetchMenuItemToppings {
        struct Request {
            var menuItemId: String
        }

        struct Response {
            var toppingGroups: [ToppingGroup]?
            var error: MenuItemErrors?
        }

        struct ViewModel {
            var toppingGroups: [ToppingGroup]?
            var error: MenuItemErrors?
        }
    }

    // MARK: OrderItems

    struct OrderAndOrderItemFormFields {
        var orderItem: OrderItemFormFields
        var restaurantId: String
        var customerId: String
    }

    struct OrderItemFormFields {
        var name: String
        var menuItemId: String
        var price: Double
        var quantity: Int
        var orderItemToppings: [OrderItemToppingFormFields]
    }

    struct OrderItemToppingFormFields {
        var name: String
        var menuItemToppingId: String
        var quantity: Int
        var price: Double
    }

    struct DisplayedOrderItem {
        var id: String
        var name: String
        var price: Double
        var quantity: Int
    }

    enum FetchOrderItems {
        struct Request {
            var orderId: String
        }

        struct Responce {
            var orderItems: [OrderItem]
            var error: OrderItemErrors?
        }

        struct ViewModel {
            var displayedOrderItems: [DisplayedOrderItem]
            var error: OrderItemErrors?
        }
    }

    enum CreateOrderItem {
        struct Request {
            var orderId: String?
            var orderItemFormFields: OrderItemFormFields?
        }

        struct Response {
            var order: NestedOrder?
            var error: OrderItemErrors?
        }

        struct ViewModel {
            var order: Order?
            var orderItems: [OrderItem]?
            var error: OrderItemErrors?
        }
    }

    enum CreateOrderAndOrderItems {
        struct Request {
            var orderAndOrderItemFormFields: OrderAndOrderItemFormFields?
        }

        struct Response {
            var order: NestedOrder?
            var error: OrderItemErrors?
        }

        struct ViewModel {
            var order: Order?
            var orderItems: [OrderItem]?
            var error: OrderItemErrors?
        }
    }

    
    enum ManipulateOrderItemQuantity {
        struct Request {
            var action: ManipulateOrderItemRequest
            var orderId: String?
            var orderItemId: String?
        }

        struct Response {
            var order: NestedOrder?
            var error: OrderItemErrors?
        }

        struct ViewModel {
            var order: Order?
            var orderItems: [OrderItem]?
            var error: OrderItemErrors?
        }
    }
    enum UpdateOrder {
        struct Request {
            var order: Order?
        }
        struct Response {
            var order: NestedOrder?
            var error: OrderItemErrors?
        }

        struct ViewModel {
            var order: Order?
            var orderItems: [OrderItem]?
            var error: OrderItemErrors?
        }
    }
    
    enum RemoveOrder {
        struct Request {
            var orderId: String?
        }
        struct Response {
            var order: NestedOrder?
            var error: OrderItemErrors?
        }

        struct ViewModel {
            var order: Order?
            var orderItems: [OrderItem]?
            var error: OrderItemErrors?
        }
    }
    
    enum CreateOrderItems {
        struct Request {
            var orderItemsFormFields: [OrderItemFormFields]
        }

        struct Response {
            var order: NestedOrder?
            var error: OrderItemErrors?
        }

        struct ViewModel {
            var order: Order?
            var orderItems: [OrderItem]?
            var error: OrderItemErrors?
        }
    }

    enum UpdateOrderItem {
        struct Request {
            var orderItemFormFields: OrderItemFormFields
        }

        struct Response {
            var orderItem: OrderItem?
        }

        struct ViewModel {
            var orderItem: OrderItem?
        }
    }

    enum RemoveOrderItem {
        struct Request {
            var id: String
        }

        struct Response {
            var orderItem: OrderItem?
        }

        struct ViewModel {
            var order: OrderItem?
        }
    }
}
