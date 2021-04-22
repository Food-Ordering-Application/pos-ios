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
    lazy var size = CGSize(width: floor((UIScreen.main.bounds.width - (5 * 10)) / 4), height: 126)
    
    var insets: UIEdgeInsets {
        return UIEdgeInsets(top: 200, left: 0, bottom: 200, right: 0)
    }
    
    var additionalInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    private var dataSource = PresetsDataSource()
    
    var displayedMenuItems: [Checkout.DisplayedMenuItem] = []
    
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
        setup()
    }
}

// MARK: Setup and update

extension ItemsCollectionViewController {
    
    func setup(){
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
        
        // MARK: Setup notification to fetchOrders from OrdersPageViewController

        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotificationFetchMenuItems(_:)), name: Notification.Name("FetchMenuItems"), object: nil)
    }
    
    @objc func didGetNotificationFetchMenuItems(_ notification: Notification) {
        view.hideSkeleton()
        let viewModel = notification.object as! Checkout.FetchMenuItems.ViewModel
        self.displayedMenuItems = viewModel.displayedMenuItems
        collectionView.reloadData()
        print("updateData-\(displayedMenuItems)")
    }
}

// MARK: Handle data in collection view

extension ItemsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedMenuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as? ItemCollectionViewCell else { fatalError("xib doesn't exist") }
        
        cell.setCell(displayedMenuItems[indexPath.row])
    
        // Highlighted color
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.9333369732, green: 0.4588472247, blue: 0.2666652799, alpha: 0.161368649)
        myCustomSelectionColorView.layer.cornerRadius = 8
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let attributes = dataSource[3, 0].attributes
        let attributes = createAttributePopup().attributes
        let menuItem = displayedMenuItems[indexPath.row]
//        showLightAwesomePopupMessage(attributes: attributes)
        showOrderItemPopupView(attributes: attributes, data: menuItem)
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

// MARK: Handle show popup when touch in item collection cell

extension ItemsCollectionViewController {
    fileprivate func createAttributePopup() -> PresetDescription {
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
    
    // Bumps a custom nib originated view
    private func showOrderItemPopupView(attributes: EKAttributes, data: Checkout.DisplayedMenuItem) {
        SwiftEntryKit.display(entry: MenuItemDetailView(data), using: attributes)
    }

}
