//
//  ActivateCodeViewController.swift
//  smartPOS
//
//  Created by I Am Focused on 12/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import UIKit
import SwiftEventBus

class ActivateCodeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onActivateCode(_ sender: Any) {
        let isReachable = false
        SwiftEventBus.post("ReachableInternet", sender: isReachable)
        
        self.showLoginView()
    }
    
    
    
    func showLoginView() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginViewController, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
