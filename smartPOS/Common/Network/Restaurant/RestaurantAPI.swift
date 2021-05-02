//
//  RestaurantAPI.swift
//  smartPOS
//
//  Created by I Am Focused on 25/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//
import Moya

enum RestaurantAPI {
//    case getAllOrders(limit: Int?, offset: Int?)
    case getMenu(restaurantId: String)
    case getMenuItemToppings(menuItemId: String)
}

extension RestaurantAPI: TargetType, AccessTokenAuthorizable {
    
    var authorizationType: AuthorizationType? {
        switch self {
        case .getMenuItemToppings:
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
        case .getMenu(let restaurantId):
            return "/restaurant/\(restaurantId)/get-menu-information"
        case .getMenuItemToppings:
            return "restaurant/get-menu-item-topping-info"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getMenu:
            return .get
        case .getMenuItemToppings:
            return .post
        }
    }

    var parameterEncoding: ParameterEncoding {
        switch self {
        case .getMenu:
            return URLEncoding.default
        case .getMenuItemToppings:
            return JSONEncoding.default
        }
    }

    var task: Task {
        switch self {
//        case .getAllOrders(let limit, let offset):
//            var params: [String: Any] = [:]
//            params["limit"] = limit
//            params["offset"] = offset
//            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .getMenu:
            return .requestPlain
        case .getMenuItemToppings(let menuItemId):
            return .requestParameters(parameters: ["menuItemId": menuItemId], encoding: JSONEncoding.default)
        }
    }
}
