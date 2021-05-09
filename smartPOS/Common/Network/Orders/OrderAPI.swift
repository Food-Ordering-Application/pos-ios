//
//  LauncheAPI.swift
//  SpaceXOdyssey
//
//  Created by Martin Lukacs on 18/12/2018.
//  Copyright © 2018 mdev. All rights reserved.
//

import Moya

enum OrderAPI {
    case getAllOrders(_ restaurantId: String?,_ query: String?,_ pageNumber: Int? = 1)
    case getOrder(id: String)
    case createOrderAndOrderItem(data: Checkout.OrderAndOrderItemFormFields?)
    case createOrderItem(orderId: String, data: Checkout.OrderItemFormFields?)
    case manipulateOrderItemQuantity(action: ManipulateOrderItemRequest, orderId: String, orderItemId: String)
}

extension OrderAPI: TargetType, AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        switch self {
        case .createOrderAndOrderItem, .createOrderItem, .manipulateOrderItemQuantity:
            return .bearer
        default:
            return .bearer
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var path: String {
        switch self {
        case .getAllOrders:
            return "/order/get-all-restaurant-orders"
        case .getOrder(let id):
            return "/order/\(id)"
        case .createOrderAndOrderItem:
            return "/order"
        case .createOrderItem(let orderId, _):
            return "/order/\(orderId)/add-new-item"
        case .manipulateOrderItemQuantity(let action, orderId: let orderId, _):
            return "/order/\(orderId)/\(action.rawValue)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllOrders, .getOrder:
            return .get
        case .createOrderAndOrderItem, .createOrderItem, .manipulateOrderItemQuantity:
            return .post
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .getAllOrders, .getOrder:
            return URLEncoding.default
        case .createOrderAndOrderItem, .createOrderItem, .manipulateOrderItemQuantity:
            return JSONEncoding.default
        }
    }
    
    var task: Task {
        switch self {
        case .getAllOrders(let restaurantId, let query, let pageNumber):
            var params: [String: Any] = [:]
            params["restaurantId"] = restaurantId
            params["query"] = query
            params["pageNumber"] = pageNumber
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getOrder:
            return .requestPlain
        case .createOrderAndOrderItem(let data):
            var params: [String: Any] = [:]
            params["restaurantId"] = data?.restaurantId
            params["customerId"] = data?.customerId
            
            var paramsOrderItem: [String: Any] = [:]
            paramsOrderItem["menuItemId"] = data?.orderItem.menuItemId
            paramsOrderItem["price"] = data?.orderItem.price
            paramsOrderItem["quantity"] = data?.orderItem.quantity
            
            var paramsOrderItemToppings: [Any] = []
            for orderItemTopping in data?.orderItem.orderItemToppings ?? [] {
                var paramsOrderItemTopping: [String: Any] = [:]
                paramsOrderItemTopping["menuItemToppingId"] = orderItemTopping.menuItemToppingId
                paramsOrderItemTopping["quantity"] = orderItemTopping.quantity
                paramsOrderItemTopping["price"] = orderItemTopping.price
                paramsOrderItemToppings.append(paramsOrderItemTopping)
            }
            
            paramsOrderItem["orderItemToppings"] = paramsOrderItemToppings
            params["orderItem"] = paramsOrderItem
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .createOrderItem(_, let data):
            var params: [String: Any] = [:]
            var paramsOrderItem: [String: Any] = [:]
            paramsOrderItem["menuItemId"] = data?.menuItemId
            paramsOrderItem["price"] = data?.price
            paramsOrderItem["quantity"] = data?.quantity
            var paramsOrderItemToppings: [Any] = []
            for orderItemTopping in data?.orderItemToppings ?? [] {
                var paramsOrderItemTopping: [String: Any] = [:]
                paramsOrderItemTopping["menuItemToppingId"] = orderItemTopping.menuItemToppingId
                paramsOrderItemTopping["quantity"] = orderItemTopping.quantity
                paramsOrderItemTopping["price"] = orderItemTopping.price
                paramsOrderItemToppings.append(paramsOrderItemTopping)
            }
        
            paramsOrderItem["orderItemToppings"] = paramsOrderItemToppings
            params["sendItem"] = paramsOrderItem
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .manipulateOrderItemQuantity(_, _, let orderItemId):
            return .requestParameters(parameters: ["orderItemId": orderItemId], encoding: JSONEncoding.default)
        }
        
//        case .getOrder(let id):
//            var params: [String: Any] = [:]
//            params["id"] = id
//            return .requestParameters(parameters: params, encoding: URLEncoding.default)
//        }
    }
}
