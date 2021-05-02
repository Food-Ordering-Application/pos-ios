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

        setupStyle()
    }

    lazy var top: NSLayoutConstraint = self.viewBackground.topAnchor.constraint(equalTo: self.contentView.topAnchor)
    lazy var left: NSLayoutConstraint = self.viewBackground.leftAnchor.constraint(equalTo: self.contentView.leftAnchor)
    lazy var bottom: NSLayoutConstraint = self.viewBackground.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
    lazy var right: NSLayoutConstraint = self.viewBackground.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)

    fileprivate func setupStyle() {
        viewBackground.layer.shadowColor = #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 0.8211163372)
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

    func setCell(_ data: MenuItem?) {
        if let menuItem = data {
            lbName?.text = menuItem.name
            lbPrice?.text = String(menuItem.price).currency()
//            self.setImage(imageUrl: menuItem.imageUrl)
            print("Setlected CollectionViewCell",menuItem.imageUrl, menuItem)
        }
    }
    func setImage(imageUrl: String){
        guard let url = URL(string: imageUrl) else { return }
            
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            DispatchQueue.main.async {
                self.imageItem.image = UIImage(data: data!)
            }
        }
    }
}
