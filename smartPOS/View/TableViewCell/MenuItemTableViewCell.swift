//
//  MenuItemTableViewCell.swift
//  smartPOS
//
//  Created by I Am Focused on 08/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import UIKit
struct SideMenuModel {
    var icon: UIImage
    var title: String
}
class MenuItemTableViewCell: UITableViewCell {
    class var identifier: String { return String.className(self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var lbText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Background
        self.backgroundColor = .clear
        
        // Icon
        self.iconImageView?.tintColor = .white
        
        // Title
        self.lbText?.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    open func setup() {
    }
    
    open class func height() -> CGFloat {
        return 60
    }
    
    open func setData(_ data: SideMenuModel?) {
//        self.backgroundColor = UIColor(hex: "F1F8E9")
//        self.textLabel?.font = UIFont.init(name: "Poppins-Regular", size: 18)
        self.lbText?.textColor = UIColor(hex: "9E9E9E")
        if let menu = data {
            self.lbText?.text = menu.title
            self.iconImageView?.image = menu.icon
        }
    }
    
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.alpha = 0.4
        } else {
            self.alpha = 1.0
        }
    }

}
