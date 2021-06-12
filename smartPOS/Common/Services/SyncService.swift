//
//  SyncService.swift
//  smartPOS
//
//  Created by I Am Focused on 16/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
import SwiftEventBus
import SwiftDate
class SyncService {
    init(){
//        setupSyncMachine()
        SwiftEventBus.onBackgroundThread(self, name: "POSSynced") { result in
            APIConfig.setLatestSync(latestSync: Date())
            APIConfig.setIsSynced(true)
        }
    }
    
    func setupSyncMachine() {
        let latestSync = APIConfig.getLatestSync()
        print("⏰ ⏰ ⏰ latestSync: \(String(describing: latestSync)) ⏰ ⏰ ⏰")
        let queue = DispatchQueue.global(qos: .background) // or some higher QOS level
        // Do somthing after 10.5 seconds
        queue.asyncAfter(deadline: .now() + 6 ) {
            // your task code here
            DispatchQueue.main.async {
//                SwiftEventBus.post("POSSyncMenu", sender:  MenuItemsMemStore.menu?.id)
            }
        }
    }
    
    static func canHandleLocal() -> Bool {
        return !NoInternetService.isReachable() || APIConfig.getIsSynced() ?? false
    }
}
