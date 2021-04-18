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
}

extension OrderAPI: TargetType {
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var path: String {
        switch self {
        case .getAllOrders:
            return "/orders/"
        case .getOrder(let id):
            return "/order/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllOrders, .getOrder:
            return .get
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .getAllOrders, .getOrder:
            return URLEncoding.default
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
        }
            
//        case .getOrder(let id):
//            var params: [String: Any] = [:]
//            params["id"] = id
//            return .requestParameters(parameters: params, encoding: URLEncoding.default)
//        }
        
    }
}

