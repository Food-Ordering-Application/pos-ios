//
//  LauncheAPI.swift
//  SpaceXOdyssey
//
//  Created by Martin Lukacs on 18/12/2018.
//  Copyright © 2018 mdev. All rights reserved.
//

import Moya

enum OrderAPI {
    case getAllOrders(limit: Int?, offset: Int?)
    case getOrder(id: String)
    case createOrderAndOrderItem(data: Checkout.OrderAndOrderItemFormFields?)
}

extension OrderAPI: TargetType, AccessTokenAuthorizable {
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .createOrderAndOrderItem:
            return .bearer
        default:
            return .none
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var path: String {
        switch self {
        case .getAllOrders:
            return "/orders/"
        case .getOrder(let id):
            return "/order/\(id)"
        case .createOrderAndOrderItem:
            return "/order"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllOrders, .getOrder:
            return .get
        case .createOrderAndOrderItem:
            return .post
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .getAllOrders, .getOrder:
            return URLEncoding.default
        case .createOrderAndOrderItem:
            return JSONEncoding.default
        }
    }
    
    var task: Task {
        switch self {
        case .getAllOrders(let limit, let offset):
            var params: [String: Any] = [:]
            params["limit"] = limit
            params["offset"] = offset
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
                var paramsOrderItemTopping : [String: Any] = [:]
                paramsOrderItemTopping["menuItemToppingId"] = orderItemTopping.menuItemToppingId
                paramsOrderItemTopping["quantity"] = orderItemTopping.quantity
                paramsOrderItemTopping["price"] = orderItemTopping.price
                paramsOrderItemToppings.append(paramsOrderItemTopping)
            }
            
            paramsOrderItem["orderItemToppings"] = paramsOrderItemToppings
            params["orderItem"] = paramsOrderItem
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
            
//        case .getOrder(let id):
//            var params: [String: Any] = [:]
//            params["id"] = id
//            return .requestParameters(parameters: params, encoding: URLEncoding.default)
//        }
        
    }
}

