//
//  DeliveryViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import SlideMenuControllerSwift
import UIKit
import CoreStore

class DeliveryViewController: UIViewController {
    // MARK: - EditableDataSource

    final class EditableDataSource: DiffableDataSource.TableViewAdapter<CSOrder> {

        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

            switch editingStyle {

            case .delete:
                let palette = CSDatabase.csOrders.snapshot[indexPath]
                CSDatabase.stack.perform(
                    asynchronous: { (transaction) in
                        transaction.delete(palette)
                    },
                    completion: { _ in }
                )

            default:
                break
            }
        }
    }
    
    // MARK: Private
    
    private var filterBarButton: UIBarButtonItem?
    private var dataSource: DiffableDataSource.TableViewAdapter<CSOrder>?
    
    deinit {
        CSDatabase.csOrders.removeObserver(self)
    }
    
    @IBOutlet var tableView: UITableView!
    
    var mainContens = ["data1", "data2", "data3", "data4", "data5", "data6", "data7", "data8", "data9", "data10", "data11", "data12", "data13", "data14", "data15"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerCellNib(DataTableViewCell.self)
        self.dataSource = EditableDataSource(
            tableView: self.tableView,
            dataStack: CSDatabase.stack,
            cellProvider: { (tableView, indexPath, order) in
                let cell = tableView.dequeueReusableCell(withIdentifier: DataTableViewCell.identifier) as! DataTableViewCell
                let orderId = order.id
                let data = DataTableViewCellData(imageUrl: "dummy", text: orderId ?? "No ID")
                cell.setData(data)
                return cell
            }
        )
        CSDatabase.csOrders.addObserver(self) { [weak self] (listPublisher) in
            guard let self = self else {
                return
            }
            self.dataSource?.apply(listPublisher.snapshot, animatingDifferences: true)
        }
        self.dataSource?.apply(CSDatabase.csOrders.snapshot, animatingDifferences: false)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DeliveryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DataTableViewCell.height()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "SubContentsViewController", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "SubContentsViewController") as! SubContentsViewController
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
}

//extension DeliveryViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.mainContens.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = self.tableView.dequeueReusableCell(withIdentifier: DataTableViewCell.identifier) as! DataTableViewCell
//        let data = DataTableViewCellData(imageUrl: "dummy", text: mainContens[indexPath.row])
//        cell.setData(data)
//        return cell
//    }
//}
