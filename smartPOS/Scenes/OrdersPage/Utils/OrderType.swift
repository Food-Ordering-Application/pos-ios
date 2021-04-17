//
//  OrderType.swift
//  smartPOS
//
//  Created by I Am Focused on 17/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

enum LaunchType: Int {
    case passed
    case upcoming
    
    static func getType(_ type: Int) -> LaunchType {
        switch type {
        case 0:
            return .passed
        default:
            return .upcoming
        }
    }
}
