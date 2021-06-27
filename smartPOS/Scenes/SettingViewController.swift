//
//  SettingViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import CoreStore
import SkeletonView
import UIKit
import Kingfisher

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
    var worker: CheckoutWorker? = CheckoutWorker()
    let menuItemsWorker: MenuItemsWorker? = MenuItemsWorker(menuItemsStore: MenuItemsMemStore.shared)

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

    func updateMenuItem(menuItem: MenuItem?, state: ItemState) {
        print("updateMenuItem")
        print(menuItem, state)
        guard let menuItemId = menuItem?.id else { return }

        CSDatabase.stack.perform(
            asynchronous: { transaction in
                let csMenuItem = try transaction.fetchOne(From<CSMenuItem>().where(\.$id == menuItemId))
                csMenuItem?.state = state.rawValue
            },
            completion: { [weak self] result -> Void in
                switch result {
                case .success(let storage):
                    print("MenuItem: Successfully update sqlite store: \(storage)")
                case .failure(let error):
                    print("MenuItem: Failed update sqlite store with error: \(error)")
                }
            }
        )
        // Call API
        guard var menuItem = menuItem else { return }
        menuItem.state = state
        worker?.restaurantDataManager.updateMenuItem(menuItem: menuItem, APIConfig.debugMode).done { _ in
        }.catch { error in
            print("ERROR-\(error)")
        }.finally {
            // Do Nothing
            print("Update menuItem sucesss")
        }
    }

    func updateToppingItem(toppingItem: ToppingItem?, state: ItemState) {
        print("updateToppingItem")
        print(toppingItem)
        guard let toppingItemId = toppingItem?.id else { return }
        CSDatabase.stack.perform(
            asynchronous: { transaction in
                let csToppingItem = try transaction.fetchOne(From<CSToppingItem>().where(\.$id == toppingItemId))
                csToppingItem?.state = state.rawValue
            },
            completion: { [weak self] result -> Void in
                switch result {
                case .success(let storage):
                    print("MenuItem: Successfully update sqlite store: \(storage)")
                case .failure(let error):
                    print("MenuItem: Failed update sqlite store with error: \(error)")
                }
            }
        )
        // Call API
        guard var toppingItem = toppingItem else { return }
        toppingItem.state = state
        worker?.restaurantDataManager.updateToppingItem(toppingItem: toppingItem, APIConfig.debugMode).done { _ in
        }.catch { error in
            print("ERROR-\(error)")
        }.finally {
            // Do Nothing
            print("Update toppingItem sucesss")
        }
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

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemStore")!
        cell.selectionStyle = .none
        let curSegmentIndex = segmentItems.selectedSegmentIndex
        var name: String? = "_"
        var imageURL: String = ""
        var state: ItemState? = .instock
        if curSegmentIndex == SegmentItemsTab.menuItem.rawValue {
            name = menuItems![indexPath.row].name
            state = menuItems![indexPath.row].state ?? .unknown
            imageURL =  menuItems![indexPath.row].imageUrl
        }
        if curSegmentIndex == SegmentItemsTab.toppingItem.rawValue {
            name = toppingItems![indexPath.row].name
            state = toppingItems![indexPath.row].state ?? .unknown
        }
        cell.textLabel?.text = name
      
        let image = UIImage(named: "pizza")
        cell.imageView?.image = image
//        if let imageView = cell.imageView, let url = URL(string: imageURL) {
//            
//            
//            KF.url(url)
//              .placeholder(UIImage(named: "placeholder"))
//              .loadDiskFileSynchronously()
//              .cacheMemoryOnly()
//              .fade(duration: 0.25)
//              .onProgress { receivedSize, totalSize in  }
//              .onSuccess { result in  }
//              .onFailure { error in }
//              .set(to: imageView)
//        }
        
        
        
        
        
        let isOn = state == .instock ? true : false
        // Add Switch
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(isOn, animated: false)
        switchView.tag = indexPath.row

        switchView.addTarget(self, action: #selector(onSwitchChanged(_:)), for: .valueChanged)

        cell.accessoryView = switchView
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        headerView.layer.cornerRadius = 8
        let lbName = UILabel()
//        lbName.frame = CGRect(x: 15, y: 5, width: headerView.frame.width / 2, height: headerView.frame.height-10)
        lbName.text = "Tên món ăn"
        lbName.font = MainFont.semiBold.with(size: 16)
        lbName.textColor = .gray

        let lbState = UILabel()
//        lbState.frame = CGRect(x: 15, y: 5, width: headerView.frame.width / 3, height: headerView.frame.height-10)
        lbState.text = "Trạng thái"
        lbState.font = MainFont.semiBold.with(size: 16)
        lbState.textColor = .gray

        let stackView = UIStackView(arrangedSubviews: [lbName, lbState])
        stackView.frame = CGRect(x: 15, y: 5, width: headerView.frame.width - 25, height: headerView.frame.height - 10)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        headerView.addSubview(stackView)

        return headerView
    }

    @objc func onSwitchChanged(_ sender: UISwitch?) {
        print("Table view have Switch changed")
        let curSegmentIndex = segmentItems.selectedSegmentIndex
        guard let index = sender?.tag else { return }
        let state: ItemState = sender!.isOn ? .instock : .outofstock
        if curSegmentIndex == SegmentItemsTab.menuItem.rawValue {
            updateMenuItem(menuItem: menuItems![index], state: state)
            return
        }
        if curSegmentIndex == SegmentItemsTab.toppingItem.rawValue {
            updateToppingItem(toppingItem: toppingItems![index], state: state)
            return
        }
    }
}
