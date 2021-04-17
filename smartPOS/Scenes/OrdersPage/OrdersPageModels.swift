//
//  OrdersPageModels.swift
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

enum OrdersPage {
    struct DisplayedOrder {
        var id: String
        var name: String?
        var date: String?
        var imgUrl: String?
    }
    
    // MARK: Fetch orders to display during first page load

    enum FetchOrders {
        struct Request {}
        
        struct Response {
            var orders: [Order]?
            var error: OrderErrors?
        }
        
        struct ViewModel {
            var displayedOrders: [DisplayedOrder]
            var error: OrderErrors?
        }
    }

    
    // MARK: Set orders to dispay during a search

    enum SearchOrders {
        struct Request {
            var query: String?
            var orderStatus: OrderStatus
        }
        
        struct Response {
            var orders: [Order]
        }
        
        struct ViewModel {
            var displayedOrders: [DisplayedOrder]
        }
    }
    
    
    // MARK: Set orders to display when type is changed

    enum FetchOrdersByStatus {
        struct Request {
            var orderStatus: OrderStatus
        }
        
        struct Response {
            var orders: [Order]
        }
        
        struct ViewModel {
            var displayedOrders: [DisplayedOrder]
        }
    }
    
    // MARK: Fetch orders to display after page refresh is called

    enum RefreshOrders {
        struct Request {
            var orderStatus: OrderStatus
        }
        
        struct Response {
            var orders: [Order]?
            var error: OrderErrors?
        }
        
        struct ViewModel {
            var displayedOrders: [DisplayedOrder]
            var error: OrderErrors?
        }
    }
}
