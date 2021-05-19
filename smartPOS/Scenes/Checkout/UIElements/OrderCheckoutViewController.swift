//
//  OrderCheckoutViewController.swift
//  smartPOS
//
//  Created by I Am Focused on 07/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import BouncyLayout
import EmptyDataSet_Swift
import NumPad
import SwiftEntryKit
import UIKit

struct ManipulateOrderItemModel {
    let action: ManipulateOrderItemRequest
    let orderId: String
    let orderItemId: String
}

class OrderCheckoutViewController: UIViewController, EmptyDataSetSource, EmptyDataSetDelegate {
    @IBOutlet var orderItemsTableView: UITableView!
//    @IBOutlet weak var paymentInfoArea: UIView!
    @IBOutlet var orderInfoArea: UIStackView! {
        didSet {
            self.orderInfoArea.isHidden = true
        }
    }

    @IBOutlet var btnCancelOrder: UIButton! {
        didSet {
            self.btnCancelOrder.isHidden = true
        }
    }

    @IBOutlet var lbTotal: UILabel!
    @IBOutlet var lbTax: UILabel!
    @IBOutlet var lbDiscounts: UILabel!
    @IBOutlet var lbSubTotal: UILabel!
    @IBOutlet var paymentMethod: UISegmentedControl!

    @IBOutlet var cashPaymentArea: UIStackView! {
        didSet {
            self.cashPaymentArea.isHidden = true
        }
    }

    @IBOutlet var lbReceivedCash: UILabel!
    @IBOutlet var lbExcessCash: UILabel!

    @IBOutlet var btnPayment: UIButton!

    var order: Order?
    var orderItems: [OrderItem] = []
    override func viewDidLoad() {
        self.setup()
    }

    @IBAction func doRemoveOrder(_ sender: Any) {
        guard let orderId = self.order?.id else { return }
        NotificationCenter.default.post(name: Notification.Name("RemoveOrder"), object: orderId)
    }

    @IBAction func doPlaceOrder(_ sender: Any) {
        let attributes = createAttributePopup().attributes

        self.showInputPadPopup(attributes: attributes)
        print("doPlaceOrder")
    }
}

extension OrderCheckoutViewController {
    func setup() {
        super.viewDidLoad()
        self.view.layer.borderWidth = 1
        self.view.layer.borderColor = #colorLiteral(red: 0.9333369732, green: 0.4588472247, blue: 0.2666652799, alpha: 1)
        self.view.layer.cornerRadius = 15
        self.view.layer.shadowPath = UIBezierPath(rect: self.view.bounds).cgPath
        self.setupTableView()
        self.setupOrderView()

        // MARK: Notifications

        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotificationManipulatedOrderItem(_:)), name: Notification.Name("ManipulatedOrderItem"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotificationManipulateOrderItem(_:)), name: Notification.Name("ManipulateOrderItem"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotificationCreatedOrderItem(_:)), name: Notification.Name("CreatedOrderItem"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotificationCreateOrderItem(_:)), name: Notification.Name("CreateOrderItem"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotificationCreatedOrderAndOrderItems(_:)), name: Notification.Name("CreatedOrderAndOrderItems"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotificationCreateOrderAndOrderItems(_:)), name: Notification.Name("CreateOrderAndOrderItems"), object: nil)
    }

    @objc func didGetNotificationCreateOrderItem(_ notification: Notification) {
        self.view.showSkeleton()
    }

    @objc func didGetNotificationCreateOrderAndOrderItems(_ notification: Notification) {
        self.view.showSkeleton()
    }

    @objc func didGetNotificationManipulateOrderItem(_ notification: Notification) {
        self.view.showSkeleton()
    }

    @objc func didGetNotificationManipulatedOrderItem(_ notification: Notification) {
        let viewModel = notification.object as! Checkout.ManipulateOrderItemQuantity.ViewModel
        self.updateDataOrder(order: viewModel.order)
        self.updateDataOrderItems(orderItems: viewModel.orderItems)
        self.view.hideSkeleton()
    }

    @objc func didGetNotificationCreatedOrderItem(_ notification: Notification) {
        let viewModel = notification.object as! Checkout.CreateOrderItem.ViewModel
        self.updateDataOrder(order: viewModel.order)
        self.updateDataOrderItems(orderItems: viewModel.orderItems)
        self.view.hideSkeleton()
    }

    @objc func didGetNotificationCreatedOrderAndOrderItems(_ notification: Notification) {
        let viewModel = notification.object as! Checkout.CreateOrderAndOrderItems.ViewModel
        self.updateDataOrder(order: viewModel.order)
        self.updateDataOrderItems(orderItems: viewModel.orderItems)
        self.view.hideSkeleton()
    }

    //    MARK: Handle add orderItem to Order

    func updateDataOrder(order: Order?) {
        self.order = order
        guard let orderId = order!.id else {
            self.orderInfoArea.isHidden = true
            self.btnCancelOrder.isHidden = true
            return
        }
        self.lbTotal?.text = String(order!.grandTotal).currency()
        self.lbSubTotal?.text = String(order?.grandTotal ?? 0).currency()
        self.lbDiscounts?.text = String(order?.discount ?? 0).currency()
        self.lbTax?.text = String(0).currency()
        self.setupOrderView(isHidden: false)
    }

    func updateDataOrderItem(orderItem: OrderItem?) {
        self.orderItems.append(orderItem!)
        self.orderItemsTableView.reloadData()
    }

    func updateDataOrderItems(orderItems: [OrderItem]?) {
        self.orderItems = orderItems!
        self.orderItemsTableView.reloadData()
    }

    func setupOrderView(isHidden: Bool = true) {
        self.btnCancelOrder.isHidden = isHidden
        self.orderInfoArea.isHidden = isHidden
    }

    // MARK: Register tableView for xib cell

    func setupTableView() {
        self.orderItemsTableView.separatorStyle = .none
        self.orderItemsTableView.register(OrderItemTableViewCell.nib, forCellReuseIdentifier: OrderItemTableViewCell.identifier)
        self.orderItemsTableView.emptyDataSetView { [weak self] view in
            if let `self` = self {
                view.titleLabelString(NSAttributedString(string: "Empty!"))
            }
        }
    }
}

// MARK: Handle show Numpad when touch in btnPayment

extension OrderCheckoutViewController {
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
    private func showInputPadPopup(attributes: EKAttributes) {
        SwiftEntryKit.display(entry: NumpadView(frame: CGRect(x: 0, y: 0, width: 600, height: 800)), using: attributes)
    }
}

// MARK: Setup tableview for OrderItems

extension OrderCheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return OrderItemTableViewCell.height()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let menu = LeftMenu(rawValue: indexPath.row) {
//            self.changeViewController(menu)
//        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.orderItemsTableView == scrollView {}
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderItemTableViewCell.identifier, for: indexPath) as? OrderItemTableViewCell else { fatalError("xib doesn't exist") }
        cell.setData(self.orderItems[indexPath.row])
        // Highlighted color
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.9333369732, green: 0.4588472247, blue: 0.2666652799, alpha: 0.161368649)
        myCustomSelectionColorView.layer.cornerRadius = 8
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }
}
