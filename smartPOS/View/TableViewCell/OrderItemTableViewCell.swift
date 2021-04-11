//
//  OrderItemTableViewCell.swift
//  smartPOS
//
//  Created by I Am Focused on 09/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import UIKit
struct OrderItem {
    var name: String?
}

class OrderItemTableViewCell: UITableViewCell {
    class var identifier: String { return String.className(self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet var imageItem: UIImageView!
    @IBOutlet var lbName: UILabel!
    @IBOutlet var lbDescription: UILabel!
    @IBOutlet var lbPrice: UILabel!
    @IBOutlet var lbAmount: UILabel!
    @IBOutlet var btnMinusItem: UIButton!
    @IBOutlet var btnPlusItem: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        print("Selected Item:\(self.lbName.text!)")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    open func setup() {}
    
    open class func height() -> CGFloat {
        return 60
    }
    
    open func setData(_ data: OrderItem?) {
//        self.backgroundColor = UIColor(hex: "F1F8E9")
//        self.textLabel?.font = UIFont.init(name: "Poppins-Regular", size: 18)
//        self.lbText?.textColor = UIColor(hex: "9E9E9E")
        if let menu = data {
            self.lbName?.text = menu.name
        }
        print(data!)
    }
    
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.alpha = 0.4
        } else {
            self.alpha = 1.0
        }
    }

    func doRemoveItem(_ sender: Any) {
        print("Remove")
    }

    @IBAction func doMinusItem(_ sender: Any) {
//        guard lbAmount.text as NumberFormatter else {
//            doRemoveItem(sender)
//            return
//        }
//        print(curAmount)
        print("Minus \(self.lbName.text!)")
        
    }
    
    @IBAction func doPlusItem(_ sender: Any) {
        print("Plus")
    }
}
