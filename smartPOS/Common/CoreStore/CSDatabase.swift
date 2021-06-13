//
//  CSDatabase.swift
//  smartPOS
//
//  Created by I Am Focused on 14/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
import CoreStore

struct CSDatabase {
    static func uuid() -> String {
        return UUID().uuidString
    }
    static let stack: DataStack = {

        let dataStack = DataStack(
            CoreStoreSchema(
                modelVersion: "MyPOS",
                entities: [
                    Entity<CSMenu>("CSMenu"),
                    Entity<CSMenuItem>("CSMenuItem"),
                    Entity<CSMenuItemGroup>("CSMenuItemGroup"),
                    Entity<CSMenuItemTopping>("CSMenuItemTopping"),
                    Entity<CSToppingItem>("CSToppingItem"),
                    Entity<CSToppingGroup>("CSToppingGroup"),
                    Entity<CSOrder>("CSOrder"),
                    Entity<CSOrderItem>("CSOrderItem"),
                    Entity<CSOrderItemTopping>("CSOrderItemTopping"),
                ],
                versionLock: [
                    "CSMenu": [0xbb05b7be0993a640, 0x94591630715a2a70, 0x145ee6b543785f00, 0x24bfefd889efa60b],
                    "CSMenuItem": [0xb9eb252146e77d9f, 0xcf6b0a649bfec5a, 0x162bdbbd1b30d153, 0xc871cad8976935dc],
                    "CSMenuItemGroup": [0x429c8c1ea1d6aa27, 0xf9e17d18c6b944af, 0x835644cbb1947713, 0x1ee0e175239bf921],
                    "CSMenuItemTopping": [0x753962372555d26, 0x4d4385614063fdc7, 0x1375de5c0c0ef941, 0x6fb4ff297a92a23a],
                    "CSOrder": [0xe07636810d2340b0, 0x512f60b06a079837, 0xbefb38dc55d63b31, 0x4fb233e1330deff5],
                    "CSOrderItem": [0x1c8ab5b6c56be1aa, 0x9baaaee5a9e1631f, 0x574ca317015ad367, 0xd23e146d36104dd4],
                    "CSOrderItemTopping": [0x36e60b0ce9f32f59, 0x9368204355baf860, 0x2bacdcb9ebd385a4, 0x46ecd15aceeb4b3d],
                    "CSToppingGroup": [0x839896f33c6b2093, 0x545cca21f23c9db8, 0xabf8d982bd10cbd6, 0xfce639a416d17088],
                    "CSToppingItem": [0x6a544d22f8201a9b, 0x9ed185fbe9e0cf3d, 0x6a5adf0545401898, 0xe6efcc42b84ead0b]
                ]
            )
        )
        
        try! dataStack.addStorageAndWait(
            SQLiteStore(
                fileName: "MyPOS.sqlite",
                localStorageOptions: .recreateStoreOnModelMismatch
            )
        )
        return dataStack
    }()
    
    static let csMenuitems: ListPublisher<CSMenuItem> = {
        return CSDatabase.stack.publishList(
            From<CSMenuItem>()
                .orderBy(.ascending(\.$id))
        )
    }()
    
    static let csOrders: ListPublisher<CSOrder> = {
        return CSDatabase.stack.publishList(
            From<CSOrder>()
                .sectionBy(\.$dateName)
                .orderBy(.descending(\.$createdAt))
        )
    }()
    
}
