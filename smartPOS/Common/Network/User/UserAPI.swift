//
//  UserAPI.swift
//  smartPOS
//
//  Created by I Am Focused on 23/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//
import Moya

enum UserAPI {
    case login(username: String, password: String, restaurantId: String)
    case verifyKey(posAppKey: String, deviceId: String)
}

extension UserAPI: TargetType, AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        switch self {
//        case .login, .verifyKey:
//            return .bearer
        default:
            return .none
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }

    var path: String {
        switch self {
        case .login:
            return "user/pos/login"
        case .verifyKey:
            return "​​user​/pos​/verify-app-key"
        }
    }

    var method: Moya.Method {
        switch self {
        case .login, .verifyKey:
            return .post
        }
    }

    var parameterEncoding: ParameterEncoding {
        switch self {
        case .login, .verifyKey:
            return JSONEncoding.default
        }
    }

    var task: Task {
        switch self {
        case .login(let username, let password, let restaurantId):
            var params: [String: Any] = [:]
            params["username"] = username
            params["password"] = password
            params["restaurantId"] = restaurantId
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .verifyKey(let posAppKey, let deviceId):
            var params: [String: Any] = [:]
            params["posAppKey"] = posAppKey
            params["deviceId"] = deviceId
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
}
