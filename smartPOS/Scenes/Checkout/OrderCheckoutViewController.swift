//
//  OrderCheckoutViewController.swift
//  smartPOS
//
//  Created by I Am Focused on 07/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import UIKit

class OrderCheckoutViewController: UIViewController {
    @IBOutlet var mainView: UIView!
    
    public let widthMainView: Float = 600.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        self.setupLayout()
    } /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

    func setupLayout(){
        self.addLeftBorder()
        self.mainView.backgroundColor = UIColor.white.withAlphaComponent(0.98)
        self.mainView.layer.cornerRadius = 15
    }
    
    func addLeftBorder() {
        let thickness: CGFloat = 2.0
        let leftBorder = CALayer()
        leftBorder.frame = CGRect(x: 0.0, y: 0.0, width: thickness, height: self.mainView.frame.size.height)
        leftBorder.backgroundColor = UIColor.orange.withAlphaComponent(0.6).cgColor
        self.mainView.layer.addSublayer(leftBorder)
    }
}
