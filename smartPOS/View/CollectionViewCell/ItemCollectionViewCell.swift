//
//  ItemCollectionViewCell.swift
//  smartPOS
//
//  Created by I Am Focused on 07/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    class var identifier: String { return String.className(self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    @IBOutlet var lbName: UILabel!
    @IBOutlet var lbDescription: UILabel!
    @IBOutlet var lbPrice: UILabel!
    @IBOutlet var imageItem: UIImageView!
    @IBOutlet var viewBackground: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBackground.backgroundColor = #colorLiteral(red: 0.9333369732, green: 0.4588472247, blue: 0.2666652799, alpha: 0.02294921873)
        viewBackground.layer.cornerRadius = 15
        viewBackground.layer.borderWidth = 1
        viewBackground.layer.borderColor = #colorLiteral(red: 0.9333369732, green: 0.4588472247, blue: 0.2666652799, alpha: 1)
        top.constant = 5
        left.constant = 10
        bottom.constant = -5
        right.constant = -10

        contentView.backgroundColor = nil
        NSLayoutConstraint.activate([top, left, bottom, right])

        clipsToBounds = true
    }

    lazy var top: NSLayoutConstraint = self.viewBackground.topAnchor.constraint(equalTo: self.contentView.topAnchor)
    lazy var left: NSLayoutConstraint = self.viewBackground.leftAnchor.constraint(equalTo: self.contentView.leftAnchor)
    lazy var bottom: NSLayoutConstraint = self.viewBackground.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
    lazy var right: NSLayoutConstraint = self.viewBackground.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)

}
