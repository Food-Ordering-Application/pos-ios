//
//  RestaurantNetworkInjected.swift
//  smartPOS
//
//  Created by I Am Focused on 25/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import PromiseKit

/// Name of the protocol to inject the network dependency managing the launches
protocol RestaurantNetworkInjected { }

/// Structure used to inject a instance of RestaurantDataManager into the RestaurantNetworkInjected protocol
struct RestaurantNetworkInjector {
    static var networkManager: RestaurantDataManager = RestaurantNetworkManager()
}

// MARK: - Extension of protocol including variable containing mechanism to inject
extension RestaurantNetworkInjected {
    var restaurantDataManager: RestaurantDataManager {
        return RestaurantNetworkInjector.networkManager
    }
}

protocol RestaurantDataManager: class {
    func getMenu(restaurantId: String, _ debugMode: Bool) -> Promise<RestaurantMenuResponse>
    func getMenuItemToppings(menuItemId: String, _ debugMode: Bool) -> Promise<MenuItemToppingsResponse>
    func getCSMenuItemToppings(menuId: String, _ debugMode: Bool) -> Promise<CSMenuItemToppingsResponce>
    func getCSToppingItems(menuId: String, _ debugMode: Bool) -> Promise<CSToppingItemsResponce>
    func getCSToppingGroups(menuId: String, _ debugMode: Bool) -> Promise<CSToppingGroupsResponce>
}

extension RestaurantDataManager {
    func getMenu(restaurantId: String, _ debugMode: Bool) -> Promise<RestaurantMenuResponse> {
        return getMenu(restaurantId: restaurantId, debugMode)
    }
    func getMenuItemToppings(menuItemId: String, _ debugMode: Bool) -> Promise<MenuItemToppingsResponse> {
        return getMenuItemToppings(menuItemId: menuItemId, debugMode)
    }
}

/// Class implementing the RestaurantDataManager protocol. Used by RestaurantNetworkInjector in non test cases
final class RestaurantNetworkManager: RestaurantDataManager {
    
    
    /// List api for get information of menuItem referrence for offline
    /// - Parameters:
    ///   - menuId: The id number of the menu
    /// - Returns: Promise
    func getCSMenuItemToppings(menuId: String, _ debugMode: Bool) -> Promise<CSMenuItemToppingsResponce> {
        return APIManager.callApi(RestaurantAPI.getCSMenuItemToppings(menuId: menuId), dataReturnType: CSMenuItemToppingsResponce.self, debugMode: debugMode)
    }
    
    func getCSToppingItems(menuId: String, _ debugMode: Bool) -> Promise<CSToppingItemsResponce> {
        return APIManager.callApi(RestaurantAPI.getCSToppingItems(menuId: menuId), dataReturnType: CSToppingItemsResponce.self, debugMode: debugMode)
    }
    
    func getCSToppingGroups(menuId: String, _ debugMode: Bool) -> Promise<CSToppingGroupsResponce> {
        return APIManager.callApi(RestaurantAPI.getCSToppingGroups(menuId: menuId), dataReturnType: CSToppingGroupsResponce.self, debugMode: debugMode)
    }

    func getMenuItemToppings(menuItemId: String, _ debugMode: Bool) -> Promise<MenuItemToppingsResponse> {
        return APIManager.callApi(RestaurantAPI.getMenuItemToppings(menuItemId: menuItemId), dataReturnType: MenuItemToppingsResponse.self, debugMode: debugMode)
    }
    
    /// Get one specific launch
    ///
    /// - Parameters:
    ///   - id: The id number of the desired order
    ///   - debugMode: Togles Moya's verbose mode in console
    /// - Returns: Promise containing a specific launch
    func getMenu(restaurantId: String, _ debugMode: Bool) -> Promise<RestaurantMenuResponse> {
        return APIManager.callApi(RestaurantAPI.getMenu(restaurantId: restaurantId), dataReturnType: RestaurantMenuResponse.self,  debugMode: debugMode)
    }
}
