//
//  DeeplinkNavigator.swift
//  Deeplinks
//
//  Created by Stanislav Ostrovskiy on 5/25/17.
//  Copyright © 2017 Stanislav Ostrovskiy. All rights reserved.
//

import Foundation
import UIKit

class DeeplinkNavigator {
    static let shared = DeeplinkNavigator()
    private init() {}
    
    var alertController = UIAlertController()
    
    func proceedToDeeplink(_ type: DeeplinkType) {
        switch type {
        case .activity:
            displayAlert(title: "Activity")
        case .orders(.root):
            displayAlert(title: "Messages Root")
        case .orders(.details(id: let id)):
            openOrderDetailView(orderId: id)
//            displayAlert(title: id)
        case .newListing:
            displayAlert(title: "New Listing")
        case .request(id: let id):
            displayAlert(title: "Request Details \(id)")
        }
    }
    
    private func displayAlert(title: String) {
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okButton)
        alertController.title = title
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            if vc.presentedViewController != nil {
                alertController.dismiss(animated: false, completion: {
                    vc.present(self.alertController, animated: true, completion: nil)
                })
            } else {
                vc.present(alertController, animated: true, completion: nil)
            }
        }
    }

    // MARK: Open OrderDetail View

    func openOrderDetailView(orderId: String?) {
        print("openOrderDetailView: \(orderId)")
        guard let orderId = orderId else { return }
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        let rightViewController = storyboard.instantiateViewController(withIdentifier: "RightViewController") as! RightViewController
        
        let nvc = UINavigationController(rootViewController: mainViewController)
        
        UINavigationBar.appearance().tintColor = UIColor(hex: "FF6B35")
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController, rightMenuViewController: rightViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        slideMenuController.modalPresentationStyle = .fullScreen
        
        alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okButton)
        alertController.title = orderId
        
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            if vc.presentedViewController != nil {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("OrderDetailPage"), object: orderId)
                }
            } else {
                vc.present(slideMenuController, animated: false) {
                    NotificationCenter.default.post(name: Notification.Name("OrderDetailPage"), object: orderId)
                }
            
            }
        
        }
        
        
    }
}
