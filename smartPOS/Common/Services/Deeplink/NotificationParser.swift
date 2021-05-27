//
//  NotificationParser.swift
//  smartPOS
//
//  Created by I Am Focused on 27/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation

class NotificationParser {
    static let shared = NotificationParser()
    private init() {}
    
    
    func handleNotification(_ userInfo: [AnyHashable: Any]) -> DeeplinkType? {
        if let data = userInfo["data"] as? [String: Any] {
            if let orderId = data["orderId"] as? String {
                NotificationCenter.default.post(name: Notification.Name("OrderDetailNotification"), object: orderId)
                return DeeplinkType.orders(.details(id: orderId))
            }
        }
//        self.openOrderDetailView(orderId: "62983c29-b5d0-4f28-9d66-fefc664c6aec")
        return nil
    }
    
  
}
