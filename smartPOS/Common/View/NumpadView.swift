//
//  NumpadView.swift
//  smartPOS
//
//  Created by I Am Focused on 24/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import NumPad
import SwiftEntryKit
import UIKit
class NumpadView: UIView {
    @IBOutlet var btnBackspace: UIButton! {
        didSet {
            btnBackspace.layer.borderWidth = 1.0
            btnBackspace.layer.borderColor = borderColor.cgColor
            btnBackspace.setImage(UIImage(named: "ic_clear"), for: .normal)
            btnBackspace.imageEdgeInsets = UIEdgeInsets(top: 30, left: 50, bottom: 30, right: 50)
        }
    }

    @IBOutlet var btnSubmit: UIButton! {
        didSet {
            btnSubmit.layer.cornerRadius = 4
        }
    }

    @IBOutlet var textField: UITextField! {
        didSet {
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.textAlignment = .right
            textField.textColor = UIColor(white: 0.3, alpha: 1)
            textField.font = .systemFont(ofSize: 40)
            textField.placeholder = "0".currency()
            textField.isEnabled = false
        }
    }

    @IBOutlet var containerView: UIView!
    var numPad = NumPad(frame: CGRect(x: 0, y: 0, width: 600, height: 460))
    
    let borderColor = UIColor(white: 0.9, alpha: 1)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init(_ data: MenuItem?) {
        super.init(frame: .zero)
        setup()
//        if let menuItem = data {
//            self.displayedMenuItem = menuItem
//            self.lbName!.text = menuItem.name
//            self.lbPrice!.text = String(menuItem.price)
//            self.lbQuantity!.text = "1"
//        }
    }
    
    @IBAction func onBackspace(_ sender: Any) {
        var cash = textField.text!.sanitized()
        print(cash)
        if cash.length > 0 {
            cash.removeLast()
        }
        if cash.length != 0 {
            textField.text = String(format: "%.0f", cash).currency()
            return
        }
        textField.text = nil
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        guard let cashText = textField.text else { return }
        if cashText != "" {
            let cash = cashText.sanitized()
            NotificationCenter.default.post(name: Notification.Name("PaidByCash"), object: cash)
        }
        SwiftEntryKit.dismiss()
    }
    
    private func setup() {
        fromNib()

        numPad.backgroundColor = borderColor
        numPad.dataSource = self
        numPad.delegate = self
        containerView.addSubview(numPad)
        
        clipsToBounds = true
        layer.cornerRadius = 5
    }
}

extension NumpadView: NumPadDelegate, NumPadDataSource {
    public func numberOfRowsInNumPad(_ numPad: NumPad) -> Int {
        return 4
    }
    
    public func numPad(_ numPad: NumPad, numberOfColumnsInRow row: Row) -> Int {
        return 3
    }
    
    public func numPad(_ numPad: NumPad, itemAtPosition position: Position) -> Item {
        var item = Item()
        item.title = {
            switch position {
            case (3, 0):
                return "C"
            case (3, 1):
                return "0"
            case (3, 2):
                return "00"
            default:
                var index = (0 ..< position.row).map { self.numPad(self.numPad, numberOfColumnsInRow: $0) }.reduce(0, +)
                index += position.column
                return "\(index + 1)"
            }
        }()
        item.titleColor = {
            switch position {
            case (3, 0):
                return .orange
            default:
                return UIColor(white: 0.3, alpha: 1)
            }
        }()
        item.font = .systemFont(ofSize: 40)
        return item
    }
    
    func numPad(_ numPad: NumPad, itemTapped item: Item, atPosition position: Position) {
        switch (position.row, position.column) {
        case (3, 0):
            textField.text = nil
        default:
            let item = numPad.item(forPosition: position)!
            let string = textField.text!.sanitized() + item.title!
            if Int(string) == 0 {
                textField.text = nil
            } else {
                textField.text = string.currency()
            }
        }
    }
}
