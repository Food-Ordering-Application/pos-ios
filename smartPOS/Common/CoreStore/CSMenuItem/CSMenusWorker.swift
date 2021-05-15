//
//  MenuItemsDemo.swift
//  smartPOS
//
//  Created by I Am Focused on 13/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
import CoreStore

struct CSMenusWorker {
    
    static let menuItemConfiguration = "CSMenuItem"
    static let stack: DataStack = {

        let dataStack = DataStack(
            CoreStoreSchema(
                modelVersion: "MenuItemsDemo",
                entities: [
                    Entity<CSMenu>("CSMenu"),
                    Entity<CSMenuItem>("CSMenuItem"),
                    Entity<CSMenuItemGroup>("CSMenuItemGroup"),
                    Entity<CSMenuItemTopping>("CSMenuItemTopping"),
                    Entity<CSToppingItem>("CSToppingItem"),
                    Entity<CSToppingGroup>("CSToppingGroup"),
                ],
                versionLock: [
                    "CSMenu": [0x6febde7d733c40a3, 0x83105620a4488eed, 0x6ba31f440104d6f7, 0x9955b41131e609dd],
                    "CSMenuItem": [0xabb885400c0f9a7c, 0x8151c20bda873cfe, 0x69cb566cf129119c, 0xd2fb542fa103663f],
                    "CSMenuItemGroup": [0x81d9353d6519ec9a, 0x89fbb9b05c0af2c5, 0xbdaf637c78c93abb, 0x26b5e82f6b1bd85e],
                    "CSMenuItemTopping": [0x5a0d7bf65ec02add, 0xf5f5c0101501d655, 0xf31e474fb59c0498, 0x3664289798e7da0],
                    "CSToppingGroup": [0x854fdb925664cf35, 0x3d00690549474710, 0xacd6ac6aea66c6b8, 0xac441da2dde65047],
                    "CSToppingItem": [0xefd8b908859a5271, 0x106073619e378ded, 0xaf2da180944bc1fb, 0x9fe70d9aa127a47]                ]
            )
        )
        
        try! dataStack.addStorageAndWait(
            SQLiteStore(
                fileName: "CSMenuItem.sqlite",
//                configuration: menuItemConfiguration,
                localStorageOptions: .recreateStoreOnModelMismatch
            )
        )
        return dataStack
    }()
    
    static let csMenuitems: ListPublisher<CSMenuItem> = {
        return CSMenusWorker.stack.publishList(
            From<CSMenuItem>()
                .orderBy(.ascending(\.$id))
        )
    }()
    
    
}
