//
//  MenuItemErrors.swift
//  smartPOS
//
//  Created by I Am Focused on 22/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//
import Foundation

enum MenuItemErrors: Error {
    case couldNotLoadMenuItems(error: String)
    case couldNotLoadMenuItemDetail(error: String)
}
