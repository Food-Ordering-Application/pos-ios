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

enum SelectedPaymentButton: Int {
    case Payment = 0
    case Complete
}

enum SelectedManipulaButton: Int {
    case Remove = 0
    case Create
}

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
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.onUpdateCash(_:)))
            self.cashPaymentArea.addGestureRecognizer(tap)
        }
    }

    @IBOutlet var lbReceivedCash: UILabel!
    @IBOutlet var lbExcessCash: UILabel!

    @IBOutlet var btnPayment: UIButton! {
        didSet {
            self.btnPayment.tag = SelectedPaymentButton.Payment.rawValue
        }
    }

    var order: Order?
    var orderItems: [OrderItem] = []
    var paymentMethods: [String]? = ["Tiền mặt", "Paypal"]

    override func viewDidLoad() {
        self.setup()
    }

    @IBAction func doRemoveOrder(_ sender: UIButton) {
        switch sender.tag {
        case SelectedManipulaButton.Create.rawValue:
            self.updateDataOrder(order: nil)
            self.updateDataOrderItems(orderItems: [])
        case SelectedManipulaButton.Remove.rawValue:
            guard let orderId = self.order?.id else { return }
            NotificationCenter.default.post(name: Notification.Name("RemoveOrder"), object: orderId)
        default:
            print("Unknown Manupulate Order Action")
        }
    }

    @IBAction func doPlaceOrder(_ sender: UIButton) {
        switch sender.tag {
        case SelectedPaymentButton.Complete.rawValue:
            guard var order = self.order else { return }
            order.status = OrderStatus.ordered
            NotificationCenter.default.post(name: Notification.Name("UpdateOrder"), object: order)
            self.setupPaidMethod(paymentType: order.paymentType)
        case SelectedPaymentButton.Payment.rawValue:
            let attributes = createAttributePopup().attributes
            self.showInputPadPopup(attributes: attributes)
            print("doPlaceOrder")
        default:
            print("Unknown Payment Action")
        }
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotificationPaidByCash(_:)), name: Notification.Name("PaidByCash"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotificationUpdatedOrder(_:)), name: Notification.Name("UpdatedOrder"), object: nil)
    }

    func setupCashInfo(isHidden: Bool = true, cash: String?) {
        self.btnPayment.isEnabled = true
        self.cashPaymentArea.isHidden = isHidden
        self.lbReceivedCash?.text = cash?.currency()
        let total = self.order?.grandTotal ?? 0
        let exCash = Double(cash ?? "0")! - total
        self.lbExcessCash?.text = String(format: "%.0f", exCash).currency()
        if exCash < 0 {
            self.btnPayment.isEnabled = false
            self.btnPayment.setTitle("Không đủ tiền :(", for: .normal)
            let amount = exCash * -1
            self.lbExcessCash?.text = String(format: "%.0f", amount).currency()
        }
    }

    func setupPaymentMethods() {
        self.paymentMethod.removeAllSegments()
        guard let methods = paymentMethods else { return }
        for (index, method) in methods.enumerated() {
            self.paymentMethod.insertSegment(withTitle: method, at: index, animated: true)
        }
        self.paymentMethod.selectedSegmentIndex = 0
    }

    func setupPaidMethod(paymentType: PaymentType?) {
        guard let paidBy = paymentType else { return }
        self.paymentMethod.removeAllSegments()
        let index = 0
        switch paidBy {
        case .cod:
            self.paymentMethod.insertSegment(withTitle: "Tiền mặt", at: index, animated: true)
        case .paypal:
            self.paymentMethod.insertSegment(withTitle: "Paypal", at: index, animated: true)
        default:
            print("Unknown paymentMethod")
        }
        self.paymentMethod.selectedSegmentIndex = index
    }

    func setupBtnComplete() {
        self.btnPayment.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        self.btnPayment.setTitle("Xác nhận", for: .normal)
        self.btnPayment.tag = SelectedPaymentButton.Complete.rawValue
    }

    func setupBtnPayment() {
        self.btnPayment.backgroundColor = #colorLiteral(red: 1, green: 0.4196078431, blue: 0.2078431373, alpha: 1)
        self.btnPayment.setTitle("Thanh toán", for: .normal)
        self.btnPayment.tag = SelectedPaymentButton.Payment.rawValue
    }

    func setupBtnRemoveOrder() {
        self.btnCancelOrder.setTitle("Huỷ đơn", for: .normal)
        self.btnCancelOrder.setTitleColor(#colorLiteral(red: 1, green: 0.4196078431, blue: 0.2078431373, alpha: 1), for: .normal)
        self.btnCancelOrder.tag = SelectedManipulaButton.Remove.rawValue
    }

    func setupBtnCreateOrder() {
        self.btnCancelOrder.setTitle("Tạo mới", for: .normal)
        self.btnCancelOrder.setTitleColor(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), for: .normal)
        self.btnCancelOrder.tag = SelectedManipulaButton.Create.rawValue
    }

    @objc func onUpdateCash(_ sender: UITapGestureRecognizer? = nil) {
        let attributes = createAttributePopup().attributes
        self.showInputPadPopup(attributes: attributes)
    }

    @objc func didGetNotificationPaidByCash(_ notification: Notification) {
        let cash = notification.object as? String
        self.setupCashInfo(isHidden: false, cash: cash)
        self.setupBtnComplete()
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

    @objc func didGetNotificationUpdatedOrder(_ notification: Notification) {
        let viewModel = notification.object as! Checkout.UpdateOrder.ViewModel
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
        self.setupPaymentMethods()
        self.setupBtnPayment()
        self.setupBtnRemoveOrder()
        if order == nil || order!.id == nil || order!.id == "" {
            self.orderInfoArea.isHidden = true
            self.btnCancelOrder.isHidden = true
            return
        }
        self.cashPaymentArea.isHidden = true
        self.btnPayment.isHidden = false
        if order?.status != OrderStatus.draft {
            self.setupBtnCreateOrder()
            self.btnPayment.isHidden = true
            self.setupPaidMethod(paymentType: order?.paymentType)
        }
        self.lbTotal?.text = String(format: "%.0f", order!.grandTotal ?? 0.0).currency()
        self.lbSubTotal?.text = String(format: "%.0f", order?.grandTotal ?? 0).currency()
        self.lbDiscounts?.text = String(format: "%.0f", order?.discount ?? 0).currency()
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
                view.detailLabelString(NSAttributedString(string: "Đơn hàng chi tiết.", attributes: [NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)]))
                    .image(UIImage.resizeImage(image: UIImage(named: "undraw_empty_cart")!, targetSize: CGSize(width: 300, height: 200)))
                    .shouldFadeIn(true)
                    .isTouchAllowed(false)
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
        cell.setData(self.orderItems[indexPath.row], orderStatus: self.order?.status)
        // Highlighted color
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.9333369732, green: 0.4588472247, blue: 0.2666652799, alpha: 0.161368649)
        myCustomSelectionColorView.layer.cornerRadius = 8
        cell.selectedBackgroundView = myCustomSelectionColorView
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let orderId = self.order?.id else { return }
        if self.order?.status != OrderStatus.draft { return }
        switch editingStyle {
        case .delete:

            let orderItem = self.orderItems[indexPath.row]
            let action = ManipulateOrderItemRequest.remove
            let manipulateOrderItem = ManipulateOrderItemModel(action: action, orderId: orderId, orderItemId: orderItem.id ?? "")
            NotificationCenter.default.post(name: Notification.Name("ManipulateOrderItem"), object: manipulateOrderItem)

        default:
            break
        }
    }
}
