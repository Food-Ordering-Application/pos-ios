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

    @IBOutlet var viewBackground: UIView!
    @IBOutlet var lbOrderID: UILabel!
    @IBOutlet var lbStatus: PaddingLabel!
    @IBOutlet var lbName: UILabel!
    @IBOutlet var lbTimeRemaining: UILabel!
    @IBOutlet var lbTotalQuantity: UILabel!
    @IBOutlet var lbDistance: UILabel!
    @IBOutlet var lbNote: UILabel!
    @IBOutlet var lbTotal: UILabel!

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
        left.constant = 5
        bottom.constant = -5
        right.constant = -5

        contentView.backgroundColor = .white
        NSLayoutConstraint.activate([top, left, bottom, right])

        clipsToBounds = true
    }

    func setCell(_ data: Order?) {
        if let order = data {
            lbOrderID?.text = order.id
            lbStatus?.text = order.status.map { $0.rawValue }
            lbNote?.text = order.note
            lbTimeRemaining?.text = "14p:20s"
            lbTotalQuantity?.text = "1"
            lbTotal?.text = String(format: "%.0f", order.grandTotal ?? 0.0).currency()
            if let driver = order.delivery {
                let distance: Float = floor((driver.distance ?? 0) / 1000)
                lbDistance?.text = "\(distance)kms"
            }
        }
    }
}
