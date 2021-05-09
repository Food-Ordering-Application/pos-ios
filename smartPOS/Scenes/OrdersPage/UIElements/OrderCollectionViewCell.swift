//
//  OrderCollectionViewCell.swift
//  smartPOS
//
//  Created by I Am Focused on 15/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import UIKit

class OrderCollectionViewCell: UICollectionViewCell {

    class var identifier: String { return String.className(self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
   
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lbOrderID: UILabel!
    @IBOutlet weak var lbStatus: PaddingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        setupStyle()
    }

    lazy var top: NSLayoutConstraint = self.viewBackground.topAnchor.constraint(equalTo: self.contentView.topAnchor)
    lazy var left: NSLayoutConstraint = self.viewBackground.leftAnchor.constraint(equalTo: self.contentView.leftAnchor)
    lazy var bottom: NSLayoutConstraint = self.viewBackground.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
    lazy var right: NSLayoutConstraint = self.viewBackground.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)

    fileprivate func setupStyle() {
        viewBackground.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        viewBackground.layer.shadowRadius = 4
        viewBackground.layer.shadowOffset = .zero
        viewBackground.layer.shadowOpacity = 0.4
        viewBackground.layer.shouldRasterize = true
        
        viewBackground.layer.cornerRadius = 8
        viewBackground.backgroundColor = .white
        top.constant = 5
        left.constant = 10
        bottom.constant = -5
        right.constant = -10

        contentView.backgroundColor = .white
        NSLayoutConstraint.activate([top, left, bottom, right])

        clipsToBounds = true
    }
    func setCell(_ data: Order?) {
        if let order = data {
            self.lbOrderID?.text = order.id
            print("Setlected CollectionViewCell", order)
        }
    }
}
