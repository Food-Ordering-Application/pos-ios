//
//  RouterProtocol.swift
//  SpaceXOdyssey
//
//  Created by Martin Lukacs on 05/01/2019.
//  Copyright © 2019 mdev. All rights reserved.
//

import UIKit

protocol RouterProtocol {
    associatedtype ViewControllerType: UIViewController
    
    var viewController: ViewControllerType? { get set }
    func present<T: UIViewController>(nibIdentifier: String, animated: Bool, modalPresentationStyle: UIModalPresentationStyle?, configure: ((T) -> Void)?, completion: ((T) -> Void)?)
    func show<T: UIViewController>(nibIdentifier: String, configure: ((T) -> Void)?)
    func showDetailViewController<T: UIViewController>(nibIdentifier: String, configure: ((T) -> Void)?)
}

extension RouterProtocol {
    
    /**
     Presents the intial view controller of the specified xib.
     
     - parameter nibIdentifier: View controller name & xib.
     - parameter configure: Configure the view controller before it is loaded.
     - parameter completion: Completion the view controller after it is loaded.
     */
    func present<T: UIViewController>(nibIdentifier: String, animated: Bool = true, modalPresentationStyle: UIModalPresentationStyle? = nil, configure: ((T) -> Void)? = nil, completion: ((T) -> Void)? = nil) {
        
        let destinationController = T(nibName: nibIdentifier, bundle: Bundle.main)
        
        if let modalPresentationStyle = modalPresentationStyle {
            destinationController.modalPresentationStyle = modalPresentationStyle
        }
        
        configure?(destinationController)
        
        viewController?.present(destinationController, animated: animated) {
            completion?(destinationController)
        }
    }
    
    /**
     Present the intial view controller of the specified xib in the primary context.
     
     - parameter nibIdentifier: View controller name & xib.
     - parameter configure: Configure the view controller before it is loaded.
     */
    func show<T: UIViewController>(nibIdentifier: String, configure: ((T) -> Void)? = nil) {
        
        let destinationController = T(nibName: nibIdentifier, bundle: Bundle.main)

        configure?(destinationController)
        
        viewController?.show(destinationController, sender: self)
    }
    
    /**
     Present the intial view controller of the specified xib in the secondary (or detail) context.
     
     - parameter nibIdentifier: View controller name & xib.
     - parameter configure: Configure the view controller before it is loaded.
     */
    func showDetailViewController<T: UIViewController>(nibIdentifier: String, configure: ((T) -> Void)? = nil) {

        let destinationController = T(nibName: nibIdentifier, bundle: Bundle.main)

        configure?(destinationController)
        
        viewController?.showDetailViewController(destinationController, sender: self)
    }
}
