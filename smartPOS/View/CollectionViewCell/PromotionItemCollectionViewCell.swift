//
//  PromotionItemCollectionViewCell.swift
//  smartPOS
//
//  Created by I Am Focused on 11/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import UIKit

class PromotionItemCollectionViewCell: UICollectionViewCell {
    class var identifier: String { return String.className(self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    @IBOutlet var viewBackground: UIView!
    @IBOutlet var primaryView: UIView!
    @IBOutlet var actionView: UIView!

    @IBOutlet var lbCode: UILabel!
    @IBOutlet var lbContent: UILabel!
    
    lazy var top: NSLayoutConstraint = self.viewBackground.topAnchor.constraint(equalTo: self.contentView.topAnchor)
    lazy var left: NSLayoutConstraint = self.viewBackground.leftAnchor.constraint(equalTo: self.contentView.leftAnchor)
    lazy var bottom: NSLayoutConstraint = self.viewBackground.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
    lazy var right: NSLayoutConstraint = self.viewBackground.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupStyle()
    }

    
    @IBAction func doUseVoucher(_ sender: Any) {
        print("do use voucher per each order")
    }
}




extension PromotionItemCollectionViewCell {
   
    fileprivate func setupStyle() {
        // Setup Layout for primaryView
        primaryView.layer.borderWidth = 1
        primaryView.layer.borderColor = #colorLiteral(red: 0.9333369732, green: 0.4588472247, blue: 0.2666652799, alpha: 1)
        primaryView.layer.shadowPath = UIBezierPath(rect: viewBackground.bounds).cgPath
        primaryView.layer.cornerRadius = 15
        primaryView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        primaryView.backgroundColor = UIColor.orange.withAlphaComponent(0.1)
        
        // Setup Layout for actionView
        actionView.layer.borderWidth = 1
        actionView.layer.borderColor = #colorLiteral(red: 0.9333369732, green: 0.4588472247, blue: 0.2666652799, alpha: 1)
        actionView.layer.shadowPath = UIBezierPath(rect: viewBackground.bounds).cgPath
        actionView.layer.cornerRadius = 15
        actionView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        actionView.backgroundColor = UIColor.orange.withAlphaComponent(0.1)
        
        NSLayoutConstraint.activate([
            actionView.leftAnchor.constraint(equalTo: primaryView.rightAnchor, constant: -1)
        ])
        
        
        viewBackground.layer.shadowColor = UIColor.orange.cgColor
        viewBackground.layer.shadowRadius = 4
        viewBackground.layer.shadowOffset = .zero
        viewBackground.layer.shadowOpacity = 0.4
        viewBackground.layer.shouldRasterize = true
//        viewBackground.layer.cornerRadius = 15

        
        top.constant = 0
        left.constant = 10
        bottom.constant = 0
        right.constant = -10

        contentView.backgroundColor = .white
        NSLayoutConstraint.activate([top, left, bottom, right])

        clipsToBounds = true
    }

}


extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
