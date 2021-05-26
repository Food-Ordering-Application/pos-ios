//
//  UserAPIMockData.swift
//  smartPOS
//
//  Created by I Am Focused on 23/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation

extension UserAPI {
    var sampleData: Data {
        switch self {
        case .login:
            return stubbedResponse("Login")
        case .verifyKey:
            return stubbedResponse("VerifyKey")
        }
        
    }
}
