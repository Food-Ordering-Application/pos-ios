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
                    "CSMenu": [0xb420c916cfd24d6f, 0x787ec1f0f1ae6b85, 0x5d8e9e374e5706ca, 0xdbdab10d2013ac2a],
                    "CSMenuItem": [0x97eb7c2103ede67a, 0x8bab85604b2f5f4f, 0x6737e2ccc4ff169b, 0x80e24c8ce3e15b1e],
                    "CSMenuItemGroup": [0x81d9353d6519ec9a, 0x89fbb9b05c0af2c5, 0xbdaf637c78c93abb, 0x26b5e82f6b1bd85e],
                    "CSMenuItemTopping": [0x5a0d7bf65ec02add, 0xf5f5c0101501d655, 0xf31e474fb59c0498, 0x3664289798e7da0],
                    "CSToppingGroup": [0x9a9670132cc03b01, 0x2fc94dffbd3c41bf, 0x6f215dcdbc630697, 0x669747f9b56d3396],
                    "CSToppingItem": [0xc1d348c703a97b4b, 0x4a658cd6108047a3, 0x9ef519df0f1e116b, 0x53907931ca89621b]
                ]
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
