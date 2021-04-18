//
//  OrdersPageInteractor.swift
//  smartPOS
//
//  Created by I Am Focused on 17/04/2021.
//  Copyright (c) 2021 Clean Swift LLC. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import PromiseKit

protocol OrdersPageBusinessLogic {
    func fetchOrders(request: OrdersPage.FetchOrders.Request)
    func fetchSearchOrders(request: OrdersPage.SearchOrders.Request)
    func fetchOrdersByStatus(request: OrdersPage.FetchOrdersByStatus.Request)
    func refreshOrders(request: OrdersPage.RefreshOrders.Request)
}

protocol OrdersPageDataStore {
    var orders: [Order]? { get set }
}

final class OrdersPageInteractor: OrdersPageBusinessLogic, OrdersPageDataStore {
    var presenter: OrdersPagePresentationLogic?
    var worker = OrdersPageWorker()
    var orders: [Order]?
    let debugMode = false

    // MARK: Fetchs launch to display during page loading
    
    func fetchOrders(request: OrdersPage.FetchOrders.Request) {
        var response: OrdersPage.FetchOrders.Response!
        
        worker.ordersDataManager.getOrders(limit: nil, offset: nil).done { orders in
            self.orders = orders
            let filteredOrders = self.getFilteredByStatusOrders(orders)
            response = OrdersPage.FetchOrders.Response(orders: filteredOrders, error: nil)
        }.catch { error in
            response = OrdersPage.FetchOrders.Response(orders: nil, error: OrderErrors.couldNotLoadOrders(error: error.localizedDescription))
        }.finally{
            self.presenter?.presentOrders(response: response)
        }
       
        
    }
    
    // MARK: Fetch launches based on a search query
    
    func fetchSearchOrders(request: OrdersPage.SearchOrders.Request) {
        let filteredLaunches = getFilteredSearchedOrders(orders, query: request.query, orderStatus: request.orderStatus)
        let response = OrdersPage.SearchOrders.Response(orders: filteredLaunches)
        self.presenter?.presentSearchedOrders(response: response)
    }
    
    // MARK: Fetch launches based on a launch type

    func fetchOrdersByStatus(request: OrdersPage.FetchOrdersByStatus.Request){
        let filteredOrders = self.getFilteredByStatusOrders(orders, orderStatus: request.orderStatus)
        let response = OrdersPage.FetchOrdersByStatus.Response(orders: filteredOrders)
        self.presenter?.presentSearchedOrdersByStatus(response: response)
    }
    
    // MARK: Refresh launches

    func refreshOrders(request: OrdersPage.RefreshOrders.Request) {
        var response: OrdersPage.RefreshOrders.Response!

        worker.ordersDataManager.getOrders(limit: nil, offset: nil).done { orders in
            self.orders = orders
            let filteredOrders = self.getFilteredByStatusOrders(orders, orderStatus: request.orderStatus)
            response = OrdersPage.RefreshOrders.Response(orders: filteredOrders, error: nil)
        }.catch { error in
            response = OrdersPage.RefreshOrders.Response(orders: nil, error: OrderErrors.couldNotLoadOrders(error: error.localizedDescription))
        }.finally {
            self.presenter?.presentRefreshedOrders(response: response)
        }
    }

}

extension OrdersPageInteractor {
    /// Gets the filtered launches based on type
    ///
    /// - Parameters:
    ///   - launches: All the launches
    ///   - typeOfLaunches: The type of launch to display (passed or upcoming)
    /// - Returns: Return a filtered array of launches
    private func getFilteredByStatusOrders(_ orders: [Order]?, orderStatus: OrderStatus = .delivering) -> [Order] {
        guard let orders = orders else { return [] }
//        let isUpcommingOrder = orderStatus == .delivering ? false : true
//        return orders.filter { $0.status == orderStatus }
        return orders
    }
    
    /// Get the filtered launches based on a query search
    ///
    /// - Parameters:
    ///   - launches: All the launches
    ///   - query: The query to apply for search
    ///   - typeOfLaunch: The typpe of launches to apply the search to
    /// - Returns: Return a filtered array based on type & query
    private func getFilteredSearchedOrders(_  orders: [Order]?, query: String?, orderStatus: OrderStatus) -> [Order] {
        guard let orders = orders  else { return [] }
        let filteredOrders = getFilteredByStatusOrders(orders, orderStatus: orderStatus)
        guard let searchText = query, !searchText.isEmpty else { return filteredOrders }
        return filteredOrders
    }
}
