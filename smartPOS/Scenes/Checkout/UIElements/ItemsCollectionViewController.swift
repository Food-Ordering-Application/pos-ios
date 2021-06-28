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
import SkeletonView
import CoreStore
import SwiftEventBus

final class ItemsCollectionViewController: UIViewController {
    // MARK: Amazing Size for each Item
    let width = floor((UIScreen.main.bounds.width - (5 * 10)) / 4)
    let height = max(floor((UIScreen.main.bounds.height - ( 240 + 126 + 20)) / 4), 136)
    lazy var size = CGSize(width: width, height: height)
    var insets: UIEdgeInsets {
        return UIEdgeInsets(top: 200, left: 0, bottom: 200, right: 0)
    }
    
    var additionalInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
    }
    
    private var dataSource = PresetsDataSource()
    
    var menuItems: [MenuItem] = []
    
    var currentGroup: Int = 0
//    lazy var menuItemDetailView: MenuItemDetailView = {
//        let detail =  MenuItemDetailView.shared
//        return detail
//    }()
    
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
        view.register(ItemCollectionViewCell.nib, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        view.isSkeletonable = true
        return view
    }()
    
    func backgroundColor() -> UIColor {
        return UIColor.white.withAlphaComponent(0.98)
    }
    
    convenience init() {
        self.init()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let width = floor((view.bounds.width - (4 * 10)) / 3)
        let height = max(floor((view.bounds.height) / 4), 146)
        size = CGSize(width: width, height: height)
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
        view.isSkeletonable = true
        collectionView.isSkeletonable = true
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

        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotificationFetchedMenuItems(_:)), name: Notification.Name("FetchedMenuItems"), object: nil)
        

//        SwiftEventBus.onMainThread(self, name: "ReachableInternet") { result in
//            let isReachable = result?.object as! Bool
//            if isReachable {
//                CSDatabase.csMenuitems.removeObserver(self)
//                NotificationCenter.default.post(name: Notification.Name("FetchMenuItems"), object: nil)
//                return
//            }
//
//            self.setupCoreStore()
//        }
//
//        
//        SwiftEventBus.onMainThread(self, name: "ReachableInternet") { _ in
//            NotificationCenter.default.post(name: Notification.Name("FetchMenuItems"), object: nil)
//        }
    }
    
    @objc func didGetNotificationFetchedMenuItems(_ notification: Notification) {
        let menuItems = notification.object as! MenuItems
        self.menuItems = menuItems
        collectionView.reloadData()
        print("updateData-\(menuItems)")
        view.hideSkeleton()
    }
}

// MARK: Handle data in collection view

extension ItemsCollectionViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ItemCollectionViewCell.identifier
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as? ItemCollectionViewCell else { fatalError("xib doesn't exist") }
        
        cell.setCell(menuItems[indexPath.row])
    
        // Highlighted color
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.9333369732, green: 0.4588472247, blue: 0.2666652799, alpha: 0.161368649)
        myCustomSelectionColorView.layer.cornerRadius = 8
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let attributes = createAttributePopup().attributes
        if indexPath.row > menuItems.count {
            return
        }
        let menuItem = menuItems[indexPath.row]
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
        attributes.windowLevel = .normal
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
    private func showOrderItemPopupView(attributes: EKAttributes, data: MenuItem) {
        SwiftEntryKit.display(entry: MenuItemDetailView(data) , using: attributes)
    }

}

// MARK: Setup CoreStore
extension ItemsCollectionViewController {
    // MARK: - EditableDataSource
    final class EditableDataSource: DiffableDataSource.CollectionViewAdapter<CSMenuItem> {

//        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//            switch editingStyle {
//
//            case .delete:
//                let palette = ColorsDemo.palettes.snapshot[indexPath]
//                ColorsDemo.stack.perform(
//                    asynchronous: { (transaction) in
//
//                        transaction.delete(palette)
//                    },
//                    completion: { _ in }
//                )
//
//            default:
//                break
//            }
//        }
    }

    
//    func setupCoreStore() {
//        self.csdataSource = EditableDataSource(
//            collectionView: self.collectionView,
//            dataStack: CSDatabase.stack,
//            cellProvider: { (collectionView, indexPath, csMenuItem) -> UICollectionViewCell? in
//                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as? ItemCollectionViewCell else { fatalError("xib doesn't exist") }
//
//                cell.setCell(csMenuItem.toStruct())
//
//                // Highlighted color
//                let myCustomSelectionColorView = UIView()
//                myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.9333369732, green: 0.4588472247, blue: 0.2666652799, alpha: 0.161368649)
//                myCustomSelectionColorView.layer.cornerRadius = 8
//                cell.selectedBackgroundView = myCustomSelectionColorView
//                return cell
//            }
//        )
//
//        CSDatabase.csMenuitems.addObserver(self) { [weak self] listPublisher in
//            print("🌝 IAM TRYING GET LIST MENUITEMS FROM LOCALSTORE")
//            guard let self = self else {
//                return
//            }
//            self.csdataSource?.apply(listPublisher.snapshot, animatingDifferences: true)
//        }
//        self.csdataSource?.apply(CSDatabase.csMenuitems.snapshot, animatingDifferences: false)
//    }
    
    
    
    
}
