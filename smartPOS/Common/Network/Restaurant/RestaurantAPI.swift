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
    case updateMenuItem(menuItem: MenuItem)
    case updateToppingItem(toppingItem: ToppingItem)
    
    // MARK: Get data for Saving at local and sync | backup
    case getCSMenuItem(menuId: String)
    case getCSMenuItemToppings(menuId: String)
    case getCSToppingItems(menuId: String)
    case getCSToppingGroups(menuId: String)
    
}

extension RestaurantAPI: TargetType, AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        switch self {
        case .getMenuItemToppings,.updateMenuItem,.updateToppingItem, .getCSMenuItem, .getCSMenuItemToppings, .getCSToppingItems, .getCSToppingGroups:
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
        case .getCSMenuItem(let menuId):
            return "/user/pos/menu/\(menuId)/menu-item"
        case .getCSMenuItemToppings(menuId: let menuId):
            return "/user/pos/menu/\(menuId)/menu-item-topping"
        case .getCSToppingItems(menuId: let menuId):
            return "/user/pos/menu/\(menuId)/topping-item"
        case .getCSToppingGroups(menuId: let menuId):
            return "/user/pos/menu/\(menuId)/topping-group"
        case .updateMenuItem(let menuItem):
            return "/user/pos/menu-item/\(menuItem.id)"
        case .updateToppingItem(let toppingItem):
            return "/user/pos/topping-item/\(toppingItem.id)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getMenu, .getCSMenuItem, .getCSMenuItemToppings, .getCSToppingItems, .getCSToppingGroups:
            return .get
        case .getMenuItemToppings:
            return .post
        case .updateMenuItem, .updateToppingItem:
            return .patch
        }
    }

    var parameterEncoding: ParameterEncoding {
        switch self {
        case .getMenu, .getCSMenuItem, .getCSMenuItemToppings, .getCSToppingItems, .getCSToppingGroups:
            return URLEncoding.default
        case .getMenuItemToppings, .updateMenuItem, .updateToppingItem:
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
        case .getMenu, .getCSMenuItem, .getCSMenuItemToppings, .getCSToppingItems, .getCSToppingGroups:
            return .requestPlain
            
        case .getMenuItemToppings(let menuItemId):
            return .requestParameters(parameters: ["menuItemId": menuItemId], encoding: JSONEncoding.default)
            
        case .updateMenuItem(let menuItem):
            var params: [String: Any] = [:]
            params["state"] = menuItem.state?.rawValue
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .updateToppingItem(let toppingItem):
            var params: [String: Any] = [:]
            params["state"] = toppingItem.state?.rawValue
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
}
