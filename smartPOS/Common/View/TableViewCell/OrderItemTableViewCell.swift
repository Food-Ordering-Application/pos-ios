//
//  OrderItemTableViewCell.swift
//  smartPOS
//
//  Created by I Am Focused on 09/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Kingfisher
import SwiftEventBus
import UIKit
class OrderItemTableViewCell: UITableViewCell {
    class var identifier: String { return String.className(self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    @IBOutlet var imageItem: UIImageView! {
        didSet {
            self.imageItem.layer.cornerRadius = 8
            self.imageItem.clipsToBounds = true
        }
    }

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
        self.btnPlusItem.layer.cornerRadius = 8
        self.btnMinusItem.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
//        print("Selected Item:\(self.lbName.text!)")
    }
    
    var orderItem: OrderItem?
    
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
        return 70
    }
    
    open func setData(_ data: OrderItem?, orderStatus: OrderStatus?) {
        if let orderItem = data {
            self.orderItem = orderItem
            self.lbName?.text = orderItem.name
            self.lbDescription?.text = "_"
            self.lbPrice?.text = String(format: "%.0f", orderItem.price ?? 0).currency()
            self.lbAmount?.text = String(orderItem.quantity ?? 1)
            self.setupBtnMinus(isRemove: orderItem.quantity == 1)
            if let imageUrl = orderItem.menuItemImageUrl {
                self.setImage(imageUrl: imageUrl)
            } else {
                self.imageItem.isHidden = true
            }
            
        }
        
        if let status = orderStatus {
            let editable = self.canEdit(orderStatus: status)
            self.setupViewOnly(isHidden: !editable)
        }
    }
    
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.alpha = 0.4
        } else {
            self.alpha = 1.0
        }
    }

    func setImage(imageUrl: String) {
        let url = URL(string: imageUrl)
        imageItem.isHidden = false
        KF.url(url)
            .placeholder(UIImage(named: "placeholder"))
            .loadDiskFileSynchronously()
            .cacheMemoryOnly(false)
            .fade(duration: 0.25)
            .onProgress { _, _ in }
            .onSuccess { _ in }
            .onFailure { _ in }
            .set(to: self.imageItem)
    }

    func setupViewOnly(isHidden: Bool = false) {
        self.btnPlusItem.isHidden = isHidden
        self.btnMinusItem.isHidden = isHidden
    }

    func canEdit(orderStatus: OrderStatus) -> Bool {
        if orderStatus == OrderStatus.draft { return true }
        return false
    }
    
    func setupBtnMinus(isRemove: Bool = false) {
        if isRemove {
            self.btnMinusItem.setImage(UIImage(named: "trash-empty"), for: UIControl.State.normal)
            self.btnMinusItem.backgroundColor = #colorLiteral(red: 0.9261852146, green: 0.2456936965, blue: 0.2003052824, alpha: 0.8211163372)
            return
        }
        self.btnMinusItem.setImage(UIImage(named: "math-minus"), for: UIControl.State.normal)
        self.btnMinusItem.backgroundColor = #colorLiteral(red: 0.8224594274, green: 0.8224594274, blue: 0.8224594274, alpha: 1)
    }
    
    func doRemoveItem(_ sender: Any) {
//        print("Remove")
        self.onUpdateOrderItem(action: ManipulateOrderItemRequest.remove)
    }

    @IBAction func doMinusItem(_ sender: Any) {
        let curQuantity = Int(self.lbAmount?.text ?? "1")
        let updatedQuantity = curQuantity! - 1
        if updatedQuantity == 0 {
            self.doRemoveItem(sender)
            return
        }
        self.updateQuantity(updatedQuantity)
        self.onUpdateOrderItem(action: ManipulateOrderItemRequest.reduce)
    }
    
    @IBAction func doPlusItem(_ sender: Any) {
        print("Plus")
        let curQuantity = Int(self.lbAmount?.text ?? "1")
        self.updateQuantity(curQuantity! + 1)
        self.onUpdateOrderItem(action: ManipulateOrderItemRequest.increase)
    }
    
    fileprivate func updateQuantity(_ quantity: Int) {
//        self.lbAmount!.text = String(quantity)
        self.setupBtnMinus(isRemove: quantity == 1)
    }

    fileprivate func onUpdateOrderItem(action: ManipulateOrderItemRequest) {
        let manipulateOrderItem = ManipulateOrderItemModel(action: action, orderId: self.orderItem?.orderId ?? "", orderItemId: self.orderItem?.id ?? "")
        SwiftEventBus.post("ManipulateOrderItem", sender: manipulateOrderItem)
    }
}
