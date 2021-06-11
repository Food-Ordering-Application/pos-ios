//
//  SettingViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import SkeletonView
import UIKit
enum SegmentItemsTab: Int {
    case menuItem = 0
    case toppingItem
}

class SettingViewController: UIViewController {
    @IBOutlet var segmentItems: UISegmentedControl! {
        didSet {
            segmentItems.selectedSegmentIndex = 0
        }
    }

    @IBOutlet var tableView: UITableView!

    let menuItemsWorker: MenuItemsWorker? = MenuItemsWorker(menuItemsStore: MenuItemsMemStore())

    let array = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let array1 = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14"]

    var menuItems: [MenuItem]? = []
    var toppingItems: [ToppingItem]? = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMenuItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarItem()

        // Declare this inside of viewWillAppear
    }

    @IBAction func onSegmentChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if index == SegmentItemsTab.menuItem.rawValue {
            fetchMenuItems()
            return
        }
        fetchToppingItems()
    }

    func fetchMenuItems() {
        menuItemsWorker?.fetchMenuItems(completionHandler: { menuItems in
            if let data = menuItems {
                self.menuItems = data
            }
            self.tableView.reloadData()
        })
    }

    func fetchToppingItems() {
        menuItemsWorker?.fetchToppingItems(completionHandler: { toppingItems in
            if let data = toppingItems {
                self.toppingItems = data
            }
            self.tableView.reloadData()
        })
    }

    func updateMenuItem(menuItem: MenuItem?) {
        print("updateMenuItem")
        print(menuItem)
    }

    func updateToppingItem(toppingItem: ToppingItem?) {
        print("updateToppingItem")
        print(toppingItem)
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentItems.selectedSegmentIndex == SegmentItemsTab.menuItem.rawValue {
            return menuItems!.count
        }
        return toppingItems!.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemStore")!

        let curSegmentIndex = segmentItems.selectedSegmentIndex
        var name: String? = "_"
        var imageURL: String? = ""
        var isActive: Bool = true
        if curSegmentIndex == SegmentItemsTab.menuItem.rawValue {
            name = menuItems![indexPath.row].name
            isActive = menuItems![indexPath.row].isActive ?? true
        }
        if curSegmentIndex == SegmentItemsTab.toppingItem.rawValue {
            name = toppingItems![indexPath.row].name
//            isActive = toppingItems![indexPath.row].isActive
        }
        cell.textLabel?.text = name
        let image = UIImage(named: "pizza")
        cell.imageView?.image = image

        // Add Switch
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(isActive, animated: false)
        switchView.tag = indexPath.row

        switchView.addTarget(self, action: #selector(onSwitchChanged(_:)), for: .valueChanged)

        cell.accessoryView = switchView
        return cell
    }

    @objc func onSwitchChanged(_ sender: UISwitch?) {
        print("Table view have Switch changed")
        let curSegmentIndex = segmentItems.selectedSegmentIndex
        guard let index = sender?.tag else { return }
        if curSegmentIndex == SegmentItemsTab.menuItem.rawValue {
            updateMenuItem(menuItem: menuItems![index])
            return
        }
        if curSegmentIndex == SegmentItemsTab.toppingItem.rawValue {
            updateToppingItem(toppingItem: toppingItems![index])
            return
        }
    }
}
