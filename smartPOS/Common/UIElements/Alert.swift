//
//  Alert.swift
//  smartPOS
//
//  Created by I Am Focused on 18/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import UIKit

struct Alert {
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }

    static func showUnableToRetrieveDataAlert(on vc: UIViewController, with: String = "Unable to SmartPOS Data", message: String = "Network Error. Please pull the screen to refresh") {
        showBasicAlert(on: vc, with: with, message: message)
    }
}
