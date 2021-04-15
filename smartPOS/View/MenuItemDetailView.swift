//
//  MenuItemDetailView.swift
//  smartPOS
//
//  Created by I Am Focused on 14/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import UIKit
import SwiftEntryKit

class MenuItemDetailView: UIView {
    
    @IBOutlet var contenView: UIView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbWeight: UILabel!
    @IBOutlet weak var imageItem: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    init(_ data: MenuItem?) {
        super.init(frame: .zero)
        setup()
        if let menuItem = data {
            self.lbName!.text = menuItem.name
            self.lbPrice!.text = String(menuItem.price)
            
        }
    }
    
    private func setup() {
        fromNib()
        clipsToBounds = true
        layer.cornerRadius = 15
        btnAdd.layer.cornerRadius = 8
    }
    @IBAction func doAddMenuItem(_ sender: Any) {
        print("Iam doAddMemuItem")
        SwiftEntryKit.dismiss()
    }
    
}
