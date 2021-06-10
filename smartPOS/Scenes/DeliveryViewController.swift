//
//  DeliveryViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import CoreStore
import SlideMenuControllerSwift
import UIKit

class DeliveryViewController: UIViewController {
    weak var delegate: LeftMenuProtocol?

    // MARK: - EditableDataSource

    final class EditableDataSource: DiffableDataSource.TableViewAdapter<CSOrder> {
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            switch editingStyle {
            case .delete:
                let palette = CSDatabase.csOrders.snapshot[indexPath]
                CSDatabase.stack.perform(
                    asynchronous: { transaction in
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerCellNib(DataTableViewCell.self)
        self.tableView.separatorStyle = .none
        self.tableView.emptyDataSetView { [weak self] view in
            if let `self` = self {
                view.detailLabelString(NSAttributedString(string: "Hiện tại chưa có đơn hàng nào.", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)]))
                    .image(UIImage.resizeImage(image: UIImage(named: "undraw_add_to_cart")!, targetSize: CGSize(width: 300, height: 200)))
                    .shouldFadeIn(true)
                    .isTouchAllowed(true)
                    .didTapDataButton {
                        self.delegate?.changeViewController(LeftMenu.main)
                    }
                    .didTapContentView {
                        self.delegate?.changeViewController(LeftMenu.main)
                    }
            }
        }
        self.dataSource = EditableDataSource(
            tableView: self.tableView,
            dataStack: CSDatabase.stack,
            cellProvider: { tableView, _, order in
                let cell = tableView.dequeueReusableCell(withIdentifier: DataTableViewCell.identifier) as! DataTableViewCell
                let orderData: Order = order.toStruct()
                let isSynced: Bool = order.isSynced
                let data = DataTableViewCellData(isSynced: isSynced, order: orderData)
                cell.setData(data)
                return cell
            }
        )
        CSDatabase.csOrders.addObserver(self) { [weak self] listPublisher in
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier, segue.destination, sender) {
        case ("OrderCheckoutViewController"?, let destinationViewController as OrderCheckoutViewController, let order as ObjectPublisher<CSOrder>):
            destinationViewController.setOrder(order)
        default:
            break
        }
    }
    
    
    
}

extension DeliveryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DataTableViewCell.height()
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let orderDetailViewController = storyboard.instantiateViewController(withIdentifier: "OrderCheckoutViewController") as! OrderCheckoutViewController
////        let order = CSDatabase.csOrders.snapshot[indexPath]
//        let order =
//
//        orderDetailViewController.modalPresentationStyle = .fullScreen
//        self.navigationController?.pushViewController(orderDetailViewController, animated: true)
//    }
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(
            withIdentifier: "OrderCheckoutViewController",
            sender: CSDatabase.csOrders.snapshot[indexPath]
        )
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black.withAlphaComponent(0.8)
    }
}

// extension DeliveryViewController: UITableViewDataSource {
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
// }
