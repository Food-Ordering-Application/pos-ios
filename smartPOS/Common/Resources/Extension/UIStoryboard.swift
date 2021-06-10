//
//  UIStoryboard.swift
//  smartPOS
//
//  Created by IAmFocused on 6/10/21.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func viewController(storyboardName:String,identifier:String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard .instantiateViewController(withIdentifier: identifier)
    }
}

