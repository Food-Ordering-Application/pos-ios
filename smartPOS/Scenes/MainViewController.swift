//
//  ViewController.swift
//  smartPOS
//
//  Created by I Am Focused on 06/3/21.
//

import SlideMenuControllerSwift
import UIKit

class MainViewController: UIViewController, SlideMenuControllerDelegate {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBar()
      
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    fileprivate func setupNavBar() {
        navigationItem.title = "Checkout"
        self.setNavigationBarItem()
    }
}
    
