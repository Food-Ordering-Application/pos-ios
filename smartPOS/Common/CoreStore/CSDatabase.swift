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
                    "CSMenuItem": [0x78d2d9ea4885969c, 0xd94b52e2b01d1e9d, 0x56056d1d63b6846c, 0xdbe0f82271393da5],
                    "CSMenuItemGroup": [0x429c8c1ea1d6aa27, 0xf9e17d18c6b944af, 0x835644cbb1947713, 0x1ee0e175239bf921],
                    "CSMenuItemTopping": [0x753962372555d26, 0x4d4385614063fdc7, 0x1375de5c0c0ef941, 0x6fb4ff297a92a23a],
                    "CSOrder": [0xa01ac2519af75eec, 0x27c1123d82ce583, 0x6f30c6185e43464b, 0x4876b0f1f554c859],
                    "CSOrderItem": [0x492faa610ff10e0b, 0xdfcce61ebd4f85ed, 0xb3932ef880ca8a50, 0x22650ced56f3f512],
                    "CSOrderItemTopping": [0x642c23073d3d0827, 0x29143a4c90a9819f, 0x4f964b8ea8d74584, 0x356aff012325bb9],
                    "CSToppingGroup": [0x839896f33c6b2093, 0x545cca21f23c9db8, 0xabf8d982bd10cbd6, 0xfce639a416d17088],
                    "CSToppingItem": [0x3c30b813927bcd05, 0x402e1a299d149580, 0xad9c37063c54ebf9, 0x444e7bba913a0ec9]
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
