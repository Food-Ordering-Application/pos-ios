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
import SwiftEventBus

class DeliveryViewController: UIViewController {
    weak var delegate: LeftMenuProtocol?

    var worker = OrdersPageWorker()
    var ordersWorker: OrdersWorker? = OrdersWorker(ordersStore: OrdersMemStore())

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
    private var orders: Orders?
    deinit {
        CSDatabase.csOrders.removeObserver(self)
    }

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ferchOrders()
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
        SwiftEventBus.onMainThread(self, name: "SearchOrdersLocal") { result in
            let keyword = result?.object as? String
            print("SearchOrdersLocal", keyword)
            CSDatabase.searchCSOrders(keyword: keyword ?? "")
        }
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

    func ferchOrders() {
        print("i am fetching order from server")
        let restaurantId = APIConfig.getRestaurantId()
        let query = "POS"
        let pageNumber = 1
        self.worker.ordersDataManager.getOrders(restaurantId: restaurantId, query: query, pageNumber: pageNumber).done { ordersRes in
            if ordersRes.statusCode >= 200 || ordersRes.statusCode <= 300 {
                let data = ordersRes.data
                self.orders = data.orders
            }
        }.catch { error in
            print("Error backup order from server: ", error)
        }.finally {
            print("order from pos")
            self.orders?.forEach { order in
                self.onBackupOrder(order: order)
            }
        }
    }

    func onBackupOrder(order: Order) {
        let orderItems = order.orderItems?.map({ orderItem -> OrderItemRes in
            OrderItemRes(id: orderItem.id, menuItemId: orderItem.menuItemId, orderId: orderItem.orderId, price: orderItem.price, name: orderItem.name, discount: orderItem.discount, subTotal: orderItem.subTotal, quantity: orderItem.quantity, state: orderItem.state, orderItemToppings: nil)
        })
        let nestedOrder = NestedOrder(id: order.id, status: order.status, cashierId: order.cashierId, restaurantId: order.restaurantId, paymentType: order.paymentType, serviceFee: order.serviceFee, subTotal: order.subTotal, grandTotal: order.grandTotal, itemDiscount: order.itemDiscount, discount: order.discount, createdAt: order.createdAt, updatedAt: order.updatedAt, note: order.note, orderItems: orderItems, delivery: order.delivery)
        self.ordersWorker?.createOrderAndOrderItems(nestedOrder: nestedOrder) { orderData in
            print("orderData", orderData)
        }
    }
}

extension DeliveryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DataTableViewCell.height()
    }

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
