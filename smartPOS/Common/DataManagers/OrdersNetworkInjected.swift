//
//  File.swift
//  smartPOS
//
//  Created by I Am Focused on 17/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import PromiseKit

/// Name of the protocol to inject the network dependency managing the launches
protocol OrdersNetworkInjected {}

/// Structure used to inject a instance of OrdersDataManager into the OrdersNetworkInjected protocol
enum OrdersNetworkInjector {
    static var networkManager: OrdersDataManager = OrdersNetworkManager()
}

// MARK: - Extension of protocol including variable containing mechanism to inject

extension OrdersNetworkInjected {
    var ordersDataManager: OrdersDataManager {
        return OrdersNetworkInjector.networkManager
    }
}

protocol OrdersDataManager: class {
    func getOrders(restaurantId: String?, query: String?, pageNumber: Int?, _ debugMode: Bool) -> Promise<OrdersResponse>
    func getOrder(id: String, _ debugMode: Bool) -> Promise<OrderDetailResponse>
    func createOrderAndOrderItem(orderAndOrderItemFormFields: Checkout.OrderAndOrderItemFormFields, _ debugMode: Bool) -> Promise<CreateOrderAndOrderItemResponse>
    func createOrderItem(orderId: String, orderItemFormFields: Checkout.OrderItemFormFields, _ debugMode: Bool) -> Promise<CreateOrderItemResponse>
    func manipulateOrderItemQuantity(action: ManipulateOrderItemRequest, orderId: String, orderItemId: String, _ debugMode: Bool) -> Promise<ManipulateOrderItemResponce>
    
    func confirmOrder(orderId: String, _ debugMode: Bool) -> Promise<ConfirmOrderResponse>

    func syncOrder(orderAndOrderItemData: OrderAndOrderItemData, _ debugMode: Bool) -> Promise<CreateOrderAndOrderItemResponse>
}

extension OrdersDataManager {
    func getOrders(restaurantId: String?, query: String?, pageNumber: Int? = 1, _ debugMode: Bool = false) -> Promise<OrdersResponse> {
        return getOrders(restaurantId: restaurantId, query: query, pageNumber: pageNumber, debugMode)
    }

    func getOrder(id: String, _ debugMode: Bool) -> Promise<OrderDetailResponse> {
        return getOrder(id: id, debugMode)
    }

    func createOrderAndOrderItem(orderAndOrderItemFormFields: Checkout.OrderAndOrderItemFormFields, _ debugMode: Bool) -> Promise<CreateOrderAndOrderItemResponse> {
        return createOrderAndOrderItem(orderAndOrderItemFormFields: orderAndOrderItemFormFields, debugMode)
    }

    func createOrderItem(orderId: String, orderItemFormFields: Checkout.OrderItemFormFields, _ debugMode: Bool) -> Promise<CreateOrderItemResponse> {
        return createOrderItem(orderId: orderId, orderItemFormFields: orderItemFormFields, debugMode)
    }

    func manipulateOrderItemQuantity(action: ManipulateOrderItemRequest, orderId: String, orderItemId: String, _ debugMode: Bool) -> Promise<ManipulateOrderItemResponce> {
        return manipulateOrderItemQuantity(action: action, orderId: orderId, orderItemId: orderItemId, debugMode)
    }
    
    func syncOrder(orderAndOrderItemData: OrderAndOrderItemData, _ debugMode: Bool) -> Promise<CreateOrderAndOrderItemResponse> {
        return syncOrder(orderAndOrderItemData: orderAndOrderItemData, debugMode)
    }
    func confirmOrder(orderId: String, _ debugMode: Bool) -> Promise<ConfirmOrderResponse> {
        return confirmOrder(orderId: orderId, debugMode)
    }
}

/// Class implementing the OrdersDataManager protocol. Used by OrdersNetworkInjector in non test cases
final class OrdersNetworkManager: OrdersDataManager {
    /// Gets all the SpaceX launches
    ///
    /// - Parameters:
    ///   - limit: Max Number of element by call
    ///   - offset: offset to apply to the call for pagination purposes
    ///   - debugMode: Togles Moya's verbose mode in console
    /// - Returns: Promise containing the launches
    func getOrders(restaurantId: String?, query: String?, pageNumber: Int?, _ debugMode: Bool) -> Promise<OrdersResponse> {
        return APIManager.callApi(OrderAPI.getAllOrders(restaurantId, query, pageNumber), dataReturnType: OrdersResponse.self, debugMode: debugMode)
    }

    /// Get one specific launch
    ///
    /// - Parameters:
    ///   - id: The id number of the desired order
    ///   - debugMode: Togles Moya's verbose mode in console
    /// - Returns: Promise containing a specific launch
    func getOrder(id: String, _ debugMode: Bool) -> Promise<OrderDetailResponse> {
        return APIManager.callApi(OrderAPI.getOrder(id: id), dataReturnType: OrderDetailResponse.self, debugMode: debugMode)
    }

    func createOrderAndOrderItem(orderAndOrderItemFormFields: Checkout.OrderAndOrderItemFormFields, _ debugMode: Bool) -> Promise<CreateOrderAndOrderItemResponse> {
        return APIManager.callApi(OrderAPI.createOrderAndOrderItem(data: orderAndOrderItemFormFields), dataReturnType: CreateOrderAndOrderItemResponse.self, debugMode: debugMode)
    }
    
    func syncOrder(orderAndOrderItemData: OrderAndOrderItemData, _ debugMode: Bool) -> Promise<CreateOrderAndOrderItemResponse> {
        return APIManager.callApi(OrderAPI.syncOrder(data: orderAndOrderItemData), dataReturnType: CreateOrderAndOrderItemResponse.self, debugMode: debugMode)
    }
    func confirmOrder(orderId: String, _ debugMode: Bool) -> Promise<ConfirmOrderResponse> {
        return APIManager.callApi(OrderAPI.confirmOrder(orderId: orderId), dataReturnType: ConfirmOrderResponse.self, debugMode: debugMode)
    }

    func createOrderItem(orderId: String, orderItemFormFields: Checkout.OrderItemFormFields, _ debugMode: Bool) -> Promise<CreateOrderItemResponse> {
        return APIManager.callApi(OrderAPI.createOrderItem(orderId: orderId, data: orderItemFormFields), dataReturnType: CreateOrderItemResponse.self, debugMode: debugMode)
    }

    func manipulateOrderItemQuantity(action: ManipulateOrderItemRequest, orderId: String, orderItemId: String, _ debugMode: Bool) -> Promise<ManipulateOrderItemResponce> {
        return APIManager.callApi(OrderAPI.manipulateOrderItemQuantity(action: action, orderId: orderId, orderItemId: orderItemId), dataReturnType: ManipulateOrderItemResponce.self, debugMode: debugMode)
    }
}
