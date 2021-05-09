//
//  MenuItemDetailView.swift
//  smartPOS
//
//  Created by I Am Focused on 14/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import SwiftEntryKit
import UIKit
import SkeletonView
struct MenuItemAndToppings {
    let menuItem: MenuItem?
    let menuItemQuantity: Int?
    let toppingItems: [ToppingItem]?
}

class MenuItemDetailView: UIView {
    @IBOutlet var contenView: UIView!
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var lbName: UILabel!
    @IBOutlet var lbPrice: UILabel!
    @IBOutlet var imageItem: UIImageView!
    @IBOutlet var tableViewTopping: UITableView!
    @IBOutlet var lbQuantity: UILabel!
    @IBOutlet var btnMinusQuantity: UIButton! {
        didSet {
            btnMinusQuantity.isEnabled = false
        }
    }
    @IBOutlet var btnPlusQuantity: UIButton!
    
    
    var selectedIndexPaths = [IndexPath]()
    
    var toppingSelection: ToppingGroups = []
    
    var menuItem: MenuItem?
    
    var menuItemQuantity: Int = 1
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    init(_ data: MenuItem?) {
        super.init(frame: .zero)
        self.setup()
        
        if let menuItem = data {
            self.menuItem = menuItem
            NotificationCenter.default.post(name: Notification.Name("FetchMenuItemToppings"), object: menuItem.id)
            self.lbName!.text = menuItem.name
            self.lbPrice!.text = String(menuItem.price).currency()
            self.lbQuantity!.text = String(menuItemQuantity)
        }
    }
    
    private func setup() {
        fromNib()
        clipsToBounds = true
        layer.cornerRadius = 15
        self.btnAdd.layer.cornerRadius = 8
        self.btnMinusQuantity.layer.cornerRadius = 8
        self.btnPlusQuantity.layer.cornerRadius = 8
        self.setupTableViewTopping()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotificationFetchedMenuItemToppings(_:)), name: Notification.Name("FetchedMenuItemToppings"), object: nil)
        tableViewTopping.isSkeletonable = true
        self.tableViewTopping.showAnimatedGradientSkeleton()
    }
    
    @objc func didGetNotificationFetchedMenuItemToppings(_ notification: Notification) {
        let toppingGroups = notification.object as! ToppingGroups
        print("didGetNotificationFetchedMenuItemToppings-\(toppingGroups)")
        self.onUpdateTopping(toppingGroups: toppingGroups)
        self.tableViewTopping.hideSkeleton()
    }
    
    
    fileprivate func setupTableViewTopping() {
        self.tableViewTopping.separatorStyle = .none
        self.tableViewTopping.allowsMultipleSelection = true
        self.tableViewTopping.estimatedRowHeight = UITableView.automaticDimension
        self.tableViewTopping.estimatedSectionHeaderHeight = UITableView.automaticDimension
        // Register TableView Cell
        self.tableViewTopping.register(RadioTableViewCell.nib, forCellReuseIdentifier: RadioTableViewCell.identifier)
        self.tableViewTopping.register(SelectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SelectionHeaderView.className)
        self.tableViewTopping.dataSource = self
        self.tableViewTopping.delegate = self
        // Update TableView with the data
        self.tableViewTopping.reloadData()
    }

    @IBAction func doAddMenuItem(_ sender: Any) {
        var toppingItems: [ToppingItem] = []
        for indexPath in selectedIndexPaths {
            let toppingItem = self.toppingSelection[indexPath.section].toppingItems[indexPath.row]
            toppingItems.append(toppingItem)
        }
        let menuItemAndToppings = MenuItemAndToppings(menuItem: self.menuItem, menuItemQuantity: self.menuItemQuantity , toppingItems: toppingItems)
        NotificationCenter.default.post(name: Notification.Name("CreateOrderItem"), object: menuItemAndToppings)
        SwiftEntryKit.dismiss()
    }

    @IBAction func doMinusQuantity(_ sender: Any) {
        print("doMinusQuantity")
        self.menuItemQuantity -= 1
        self.updateQuantity(menuItemQuantity)
    }

    @IBAction func doPlusQuantity(_ sender: Any) {
        print("doPlusQuantity")
        self.menuItemQuantity += 1
        self.updateQuantity(menuItemQuantity)
    }
    fileprivate func updateQuantity(_ quantity: Int){
        self.lbQuantity!.text = String(quantity)
        self.btnMinusQuantity.isEnabled = self.menuItemQuantity > 1
    }
}

// MARK: Fetch MenuItemDetail when view on Load

extension MenuItemDetailView {
    
    fileprivate func onUpdateTopping(toppingGroups: ToppingGroups?) {
        self.toppingSelection = toppingGroups ?? []
        self.tableViewTopping.reloadData()
    }
}



// MARK: Setting for Table View

extension MenuItemDetailView: SkeletonTableViewDelegate, SkeletonTableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.toppingSelection.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.toppingSelection[section].toppingItems.count
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
        
    }
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 2
    }
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return RadioTableViewCell.identifier
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndexPathAtCurrentSection = self.selectedIndexPaths.filter { $0.section == indexPath.section }
        for indexPath in selectedIndexPathAtCurrentSection {
            tableView.deselectRow(at: indexPath, animated: true)
            if let indexOf = selectedIndexPaths.firstIndex(of: indexPath) {
                self.selectedIndexPaths.remove(at: indexOf)
            }
        }
        self.selectedIndexPaths.append(indexPath)
    }
    
    // On DeSelection
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let index = selectedIndexPaths.firstIndex(of: indexPath) {
            self.selectedIndexPaths.remove(at: index)
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.tableViewTopping.cellForRow(at: indexPath)?.setSelected(true, animated: true)
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        self.tableViewTopping.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        return indexPath
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SelectionHeaderView.className) as! SelectionHeaderView
        header.text = self.toppingSelection[section].name
        header.displayMode = PresetsDataSource.displayMode
        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RadioTableViewCell.identifier, for: indexPath) as? RadioTableViewCell else { fatalError("xib doesn't exist") }
        cell.selectionStyle = .none
        cell.setData(self.toppingSelection[indexPath.section].toppingItems[indexPath.row])
        return cell
    }

    // MARK: - Selection
}
