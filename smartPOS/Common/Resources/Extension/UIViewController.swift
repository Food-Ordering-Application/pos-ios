//
//  UIViewControllerExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import TextFieldEffects
import UIKit
import SwiftEventBus
extension UIViewController: UITextFieldDelegate {
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
        let navBar = self.navigationController?.navigationBar

//        let btnSort = UIButton(type: .system)
//        btnSort.frame = CGRect(x: 0, y: 0, width: 120, height: 40)
//        btnSort.tintColor = UIColor.white
//        btnSort.setImage(UIImage(named: "ic_controls_icon.png"), for: .normal)
//        btnSort.imageEdgeInsets = UIEdgeInsets(top: 6, left: -10, bottom: 6, right: 34)
//        btnSort.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 14)
//        btnSort.setTitle("SORT", for: .normal)
//        btnSort.layer.borderWidth = 1.0
//        btnSort.backgroundColor = UIColor.red // --> set the background color and check
//        btnSort.layer.borderColor = UIColor.white.cgColor
        
        let width = UIScreen.main.bounds.width - 100
        let searchWidth = width * 0.7
        let syncWidth = width - searchWidth
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 46))
        
        let iconSearchV = UIImageView(image: UIImage(named: "ic_search"))
        iconSearchV.setImageColor(color: UIColor.gray)
        textField.setIcon(iconSearchV.image!)
        textField.layer.cornerRadius = 8
        textField.backgroundColor = #colorLiteral(red: 0.9371728301, green: 0.9373074174, blue: 0.9371433854, alpha: 1)
        textField.changePlaceholderColor(placeholder: "Search me...", color: UIColor.gray.withAlphaComponent(0.5))
        textField.delegate = self
        let POSStatus = POSStatusView(POSStatusModel(status: EStatus.online, time: Date()))

        let view = UIStackView(frame: CGRect(x: 0, y: 0, width: width, height: 46))
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 20
        view.addArrangedSubview(textField)
        view.addArrangedSubview(POSStatus)

        let mainTitleView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 40))
        mainTitleView.addSubview(view)

        self.navigationItem.titleView = mainTitleView
        
        navBar?.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navBar?.shadowImage = UIImage()
        navBar?.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Bold", size: 23) ?? UIFont.systemFont(ofSize: 23, weight: .semibold)]
    }

    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }

    @objc func hideKeyboardWhenTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: Handle search for each view controller

    public func textFieldDidChangeSelection(_ textField: UITextField) {
        DispatchQueue.main.asyncDeduped(target: self, after: 0.25) { [weak self] in
            let keyword = textField.text
            if let vc = UIApplication.topViewController() {
                if vc is CheckoutViewController {
                    SwiftEventBus.post("SearchMenuItems", sender: keyword)
                }
                if vc is DeliveryViewController {
                    SwiftEventBus.post("SearchOrdersDelivery", sender: keyword)
                }
                if vc is OrdersPageViewController {
                    SwiftEventBus.post("SearchOrdersLocal", sender: keyword)
                }
                if vc is SettingViewController {
                    SwiftEventBus.post("SearchCSMenuItems", sender: keyword)
                }

            }
        }
    }
    
}
