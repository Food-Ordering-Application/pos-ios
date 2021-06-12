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
        SwiftEventBus.onBackgroundThread(self, name: "POSSynced") { result in
            APIConfig.setLatestSync(latestSync: Date())
            APIConfig.setIsSynced(true)
        }
    }
    static func canHandleLocal() -> Bool {
        return !NoInternetService.isReachable() || APIConfig.getIsSynced() ?? false
//        return !NoInternetService.isReachable()
    }
}
