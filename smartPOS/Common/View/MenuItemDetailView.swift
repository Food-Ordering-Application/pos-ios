//
//  MenuItemDetailView.swift
//  smartPOS
//
//  Created by I Am Focused on 14/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import UIKit
import SwiftEntryKit

struct RadioGroup {
    var title: String =  "Group 1"
    var radioItems: [RadioItem] = [RadioItem(name: "Topping 1"), RadioItem(name: "Topping 2")]
}

struct RadioItem {
    var name: String = "Topping 1"
}


class MenuItemDetailView: UIView {
    
    @IBOutlet var contenView: UIView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbWeight: UILabel!
    @IBOutlet weak var imageItem: UIImageView!
    @IBOutlet weak var tableViewTopping: UITableView!
    
    var selectedIndexPaths = [IndexPath]()
    
    var toppingSelection: [RadioGroup] = [
        RadioGroup(title: "Group 1"),
        RadioGroup(title: "Group 2"),
        RadioGroup(title: "Group 3"),
        RadioGroup(title: "Group 4")
    ]
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    init(_ data: MenuItem?) {
        super.init(frame: .zero)
        setup()
        if let menuItem = data {
            self.lbName!.text = menuItem.name
            self.lbPrice!.text = String(menuItem.price)
        }
    }
    
    private func setup() {
        fromNib()
        clipsToBounds = true
        layer.cornerRadius = 15
        btnAdd.layer.cornerRadius = 8
        self.setupTableViewTopping()
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
        print("Iam doAddMemuItem")
        SwiftEntryKit.dismiss()
    }
    
}

// MARK: Setting for Table View

extension MenuItemDetailView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return toppingSelection.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.toppingSelection[section].radioItems.count
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let menu = LeftMenu(rawValue: indexPath.row) {
//            self.changeViewController(menu)
//        }
        
        let selectedIndexPathAtCurrentSection = selectedIndexPaths.filter({ $0.section == indexPath.section})

        for indexPath in selectedIndexPathAtCurrentSection {
            tableView.deselectRow(at: indexPath, animated: true)
            if let indexOf = selectedIndexPaths.firstIndex(of: indexPath) {
                selectedIndexPaths.remove(at: indexOf)
            }
        }
        selectedIndexPaths.append(indexPath)

    }
    
    // On DeSelection
     func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

        if let index = selectedIndexPaths.firstIndex(of: indexPath) {
            selectedIndexPaths.remove(at: index)
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
        header.text = toppingSelection[section].title
        header.displayMode = PresetsDataSource.displayMode
        return header
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RadioTableViewCell.identifier, for: indexPath) as? RadioTableViewCell else { fatalError("xib doesn't exist") }
        cell.selectionStyle = .none
        cell.setData(self.toppingSelection[indexPath.section].radioItems[indexPath.row])
        return cell
    }
    // MARK: - Selection
    

}

