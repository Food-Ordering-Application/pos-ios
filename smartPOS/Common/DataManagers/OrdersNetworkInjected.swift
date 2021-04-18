//
//  File.swift
//  smartPOS
//
//  Created by I Am Focused on 17/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//


import PromiseKit

/// Name of the protocol to inject the network dependency managing the launches
protocol OrdersNetworkInjected { }

/// Structure used to inject a instance of OrdersDataManager into the OrdersNetworkInjected protocol
struct OrdersNetworkInjector {
    static var networkManager: OrdersDataManager = OrdersNetworkManager()
}

// MARK: - Extension of protocol including variable containing mechanism to inject
extension OrdersNetworkInjected {
    var ordersDataManager: OrdersDataManager {
        return OrdersNetworkInjector.networkManager
    }
}

protocol OrdersDataManager: class {
    func getOrders(limit: Int?, offset: Int?, _ debugMode: Bool) -> Promise<Orders>
    func getOrder(id: String, _ debugMode: Bool) -> Promise<Order>
}

extension OrdersDataManager {
    func getOrders(limit: Int? = nil, offset: Int? = nil, _ debugMode: Bool = false) -> Promise<Orders> {
        return getOrders(limit: limit, offset: offset, debugMode)
    }
    func getOrder(id: String, _ debugMode: Bool) -> Promise<Order> {
        return getOrder(id: id, debugMode)
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
    func getOrders(limit: Int?, offset: Int?, _ debugMode: Bool) -> Promise<Orders> {
        return APIManager.callApi(OrderAPI.getAllOrders(limit: nil, offset: nil), dataReturnType: Orders.self,  debugMode: debugMode)
    }
    
    /// Get one specific launch
    ///
    /// - Parameters:
    ///   - id: The id number of the desired order
    ///   - debugMode: Togles Moya's verbose mode in console
    /// - Returns: Promise containing a specific launch
    func getOrder(id: String, _ debugMode: Bool) -> Promise<Order> {
        return APIManager.callApi(OrderAPI.getOrder(id: id), dataReturnType: Order.self,  debugMode: debugMode)
    }
}
