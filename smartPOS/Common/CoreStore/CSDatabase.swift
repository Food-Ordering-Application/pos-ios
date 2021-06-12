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
        return "\(UUID())"
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
                    "CSOrder": [0x99bd9875a15edf6f, 0x4256037b0544bb57, 0x16525d2be2733485, 0x26dcd37a992eadfe],
                    "CSOrderItem": [0x22949653f9421399, 0xfcf98e6919829c69, 0x124b3c80ef1075bd, 0x2fe8d5d7d03cbd4e],
                    "CSOrderItemTopping": [0x642c23073d3d0827, 0x29143a4c90a9819f, 0x4f964b8ea8d74584, 0x356aff012325bb9],
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
