//
//  ItemsCollectionViewController.swift
//  smartPOS
//
//  Created by I Am Focused on 07/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//
import BouncyLayout
import SwiftEntryKit
import UIKit

class ItemsCollectionViewController: UIViewController {
    let numberOfItems = 20
    lazy var items: [MenuItem] = { (0 ..< self.numberOfItems).map { MenuItem(id: String($0), name: "Hamburger \($0)", price: Float($0 * 100000)) } }()
    lazy var size = CGSize(width: floor((UIScreen.main.bounds.width - (5 * 10)) / 4), height: 126)
    
    var insets: UIEdgeInsets {
        return UIEdgeInsets(top: 200, left: 0, bottom: 200, right: 0)
    }
    
    var additionalInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    private var dataSource = PresetsDataSource()

    
// MARK: Setup to show list item by colection view controller using Bouncylayout
    lazy var layout = BouncyLayout(style: .regular)
    
    lazy var collectionView: UICollectionView = {
        self.layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = self.backgroundColor()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
//        view.register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
        view.register(ItemCollectionViewCell.nib, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        return view
    }()
    
    func backgroundColor() -> UIColor {
        return UIColor.white.withAlphaComponent(0.98)
    }
    
    convenience init() {
        self.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Items Collection"
        view.backgroundColor = .white
        view.clipsToBounds = true
        
        collectionView.contentInset = UIEdgeInsets(top: insets.top + additionalInsets.top, left: insets.left + additionalInsets.left, bottom: insets.bottom + additionalInsets.bottom, right: insets.right + additionalInsets.right)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: -insets.top),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -insets.left),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: insets.right)
        ])
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
        
        dataSource.setup()
    }
  
}

// MARK: Handle show popup when touch in item collection cell

extension ItemsCollectionViewController {
    
    fileprivate func createAttributePopup() -> PresetDescription{
        var attributes: EKAttributes
        var description: PresetDescription
        var descriptionString: String
        var descriptionThumb: String

        // Preset I
        attributes = PresetsDataSource().bottomAlertAttributes
        attributes.displayMode = .light
        attributes.entryBackground = .color(color: .musicBackground)
        descriptionString = "Bottom floating popup with dimmed background."
        descriptionThumb = "ic_bottom_popup"
        description = .init(
            with: attributes,
            title: "Pop Up I",
            description: descriptionString,
            thumb: descriptionThumb
        )
        return description
    }
    
    
    private func showLightAwesomePopupMessage(attributes: EKAttributes) {
        let image = UIImage(named: "ic_done_all_light_48pt")!.withRenderingMode(.alwaysTemplate)
        let title = "Awesome!"
        let description = "You are using SwiftEntryKit, and this is a pop up with important content"
        showPopupMessage(attributes: attributes,
                         title: title,
                         titleColor: .white,
                         description: description,
                         descriptionColor: .white,
                         buttonTitleColor: Color.Gray.mid,
                         buttonBackgroundColor: .white,
                         image: image)
    }
    
    
    // Bumps a custom nib originated view
    private func showOrderItemPopupView(attributes: EKAttributes, data: MenuItem) {
        SwiftEntryKit.display(entry: MenuItemDetailView(data), using: attributes)
    }
    
    private func showPopupMessage(attributes: EKAttributes,
                                  title: String,
                                  titleColor: EKColor,
                                  description: String,
                                  descriptionColor: EKColor,
                                  buttonTitleColor: EKColor,
                                  buttonBackgroundColor: EKColor,
                                  image: UIImage? = nil)
    {
        var themeImage: EKPopUpMessage.ThemeImage?
        
        if let image = image {
            themeImage = EKPopUpMessage.ThemeImage(
                image: EKProperty.ImageContent(
                    image: image,
                    displayMode: .light,
                    size: CGSize(width: 60, height: 60),
                    tint: titleColor,
                    contentMode: .scaleAspectFit
                )
            )
        }
        let title = EKProperty.LabelContent(
            text: title,
            style: .init(
                font: MainFont.medium.with(size: 24),
                color: titleColor,
                alignment: .center,
                displayMode: .light
            ),
            accessibilityIdentifier: "title"
        )
        let description = EKProperty.LabelContent(
            text: description,
            style: .init(
                font: MainFont.light.with(size: 16),
                color: descriptionColor,
                alignment: .center,
                displayMode: .light
            ),
            accessibilityIdentifier: "description"
        )
        let button = EKProperty.ButtonContent(
            label: .init(
                text: "Got it!",
                style: .init(
                    font: MainFont.bold.with(size: 16),
                    color: buttonTitleColor,
                    displayMode: .light
                )
            ),
            backgroundColor: buttonBackgroundColor,
            highlightedBackgroundColor: buttonTitleColor.with(alpha: 0.05),
            displayMode: .light,
            accessibilityIdentifier: "button"
        )
        let message = EKPopUpMessage(
            themeImage: themeImage,
            title: title,
            description: description,
            button: button
        ) {
            SwiftEntryKit.dismiss()
        }
        let contentView = EKPopUpMessageView(with: message)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}


extension ItemsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath)
//        return collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as? ItemCollectionViewCell else { fatalError("xib doesn't exist") }
        
        cell.setCell(items[indexPath.row])
    
        // Highlighted color
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.9333369732, green: 0.4588472247, blue: 0.2666652799, alpha: 0.161368649)
        myCustomSelectionColorView.layer.cornerRadius = 8
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard let cell = cell as? ItemCollectionViewCell else { return }
//        cell.setCell(self.items[indexPath.row])
//    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected menuItem", indexPath.section, indexPath.row, items[indexPath.row])
//        let attributes = dataSource[3, 0].attributes
        let attributes = self.createAttributePopup().attributes
        let menuItem = items[indexPath.row]
//        showLightAwesomePopupMessage(attributes: attributes)
        showOrderItemPopupView(attributes: attributes, data: menuItem )
    }
}

extension ItemsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
