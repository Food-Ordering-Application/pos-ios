//
//  LoginResponse.swift
//  smartPOS
//
//  Created by I Am Focused on 23/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
struct LoginResponse: Decodable {
    let statusCode: Int
    let message: String
    let data: LoginData
}

struct LoginData: Decodable {
    let user: UserData?
    let access_token: String?
}

struct UserData: Decodable {
    let id: String?
    let username: String?
    let restaurantId: String?
}
