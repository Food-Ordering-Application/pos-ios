//
//  UserNetworkInjected.swift
//  smartPOS
//
//  Created by I Am Focused on 23/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import PromiseKit
  
 
/// Name of the protocol to inject the network dependency managing the launches
protocol UserNetworkInjected {}

/// Structure used to inject a instance of UserDataManager into the RestaurantNetworkInjected protocol
enum UserNetworkInjector {
    static var networkManager: UserDataManager = UserNetworkManager()
}

// MARK: - Extension of protocol including variable containing mechanism to inject

extension UserNetworkInjected {
    var userDataManager: UserDataManager {
        return UserNetworkInjector.networkManager
    }
}

protocol UserDataManager: class {
    func login(username: String, password: String, restaurantId: String, _ debugMode: Bool) -> Promise<LoginResponse>
    func verifyKey(posAppKey: String, deviceId: String, _ debugMode: Bool) -> Promise<VerifyKeyResponse>
}

extension UserDataManager {
    func login(username: String, password: String, restaurantId: String, _ debugMode: Bool) -> Promise<LoginResponse> {
        return login(username: username, password: password, restaurantId: restaurantId, debugMode)
    }

    func verifyKey(posAppKey: String, deviceId: String, _ debugMode: Bool) -> Promise<VerifyKeyResponse> {
        return verifyKey(posAppKey: posAppKey, deviceId: deviceId, debugMode)
    }
}

/// Class implementing the UserDataManager protocol. Used by UserNetworkInjector in non test cases
final class UserNetworkManager: UserDataManager {

    /// List api for get information of menuItem referrence for offline
    /// - Parameters:
    ///   - menuId: The id number of the menu
    /// - Returns: Promise
    func login(username: String, password: String, restaurantId: String, _ debugMode: Bool) -> Promise<LoginResponse>  {
        return APIManager.callApi(UserAPI.login(username: username, password: password, restaurantId: restaurantId), dataReturnType: LoginResponse.self, debugMode: debugMode)
    }

    func verifyKey(posAppKey: String, deviceId: String, _ debugMode: Bool) -> Promise<VerifyKeyResponse>{
        return APIManager.callApi(UserAPI.verifyKey(posAppKey: posAppKey, deviceId: deviceId), dataReturnType: VerifyKeyResponse.self, debugMode: debugMode)
    }
}
