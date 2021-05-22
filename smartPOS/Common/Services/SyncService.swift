//
//  SyncService.swift
//  smartPOS
//
//  Created by I Am Focused on 16/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation
import SwiftEventBus

class SyncService {
    init(){
//        setupSyncMachine()
        SwiftEventBus.onBackgroundThread(self, name: "POSSynced") { result in
            UserDefaults.standard.setValue(Date(), forKey: "LastedSync")
        }
    }
    
    func setupSyncMachine() {
        let lastedSync = UserDefaults.standard.data(forKey: "LastedSync")
        print("⏰ ⏰ ⏰ lastedSync: \(String(describing: lastedSync)) ⏰ ⏰ ⏰")
        let queue = DispatchQueue.global(qos: .background) // or some higher QOS level
        // Do somthing after 10.5 seconds
        queue.asyncAfter(deadline: .now() + 6 ) {
            // your task code here
            DispatchQueue.main.async {
                print("Hello Iam Sync Sync Sync")
//                SwiftEventBus.post("POSSyncMenu", sender:  MenuItemsMemStore.menu?.id)
            }
        }
    }
    
    static func canHandleLocal() -> Bool {
        return !NoInternetService.isReachable() || true
//        return !NoInternetService.isReachable()
    }
}
