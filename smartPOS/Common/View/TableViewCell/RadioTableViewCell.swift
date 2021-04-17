//
//  RadioTableViewCell.swift
//  smartPOS
//
//  Created by I Am Focused on 15/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import UIKit

class RadioTableViewCell: UITableViewCell {
    class var identifier: String { return String.className(self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var radioButton: LTHRadioButton! = {
        let r = LTHRadioButton()
        r.translatesAutoresizingMaskIntoConstraints = false
        return r
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    private let selectedColor   = #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 0.8211163372)
    private let deselectedColor = UIColor.lightGray
    
    
    
    func update(with color: UIColor) {
        backgroundColor             = color
        radioButton.selectedColor   = color == .darkGray ? .white : selectedColor
        radioButton.deselectedColor = color == .darkGray ? .lightGray : deselectedColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            return radioButton.select(animated: animated)
        }
        
        radioButton.deselect(animated: animated)
    }
    
    open func setData(_ data: RadioItem?) {
        if let topping = data {
            self.lbName?.text = topping.name
        }
        print(data!)
    }
}
