//
//  OrderCheckoutViewController.swift
//  smartPOS
//
//  Created by I Am Focused on 07/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import EmptyDataSet_Swift
import UIKit
class OrderCheckoutViewController: UIViewController, EmptyDataSetSource, EmptyDataSetDelegate {
    @IBOutlet var orderItemsTableView: UITableView!
    @IBOutlet weak var paymentInfoArea: UIView!
    @IBOutlet weak var btnCancelOrder: UIButton!
    @IBOutlet weak var lbPriceOrder: UILabel!
    
    var order: Order?
    var orderItems: [OrderItem] = []
    override func viewDidLoad() {
        self.setup()
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
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotificationCreatedOrderItem(_:)), name: Notification.Name("CreatedOrderItem"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotificationCreatedOrderAndOrderItems(_:)), name: Notification.Name("CreatedOrderAndOrderItems"), object: nil)

    }
    
    @objc func didGetNotificationCreatedOrderItem(_ notification: Notification) {
        let viewModel = notification.object as! Checkout.CreateOrderItem.ViewModel
        updateDataOrderItem(orderItem: viewModel.orderItem)
    }
    
    @objc func didGetNotificationCreatedOrderAndOrderItems(_ notification: Notification) {
        let viewModel = notification.object as! Checkout.CreateOrderAndOrderItems.ViewModel
        updateDataOrder(order: viewModel.order)
        updateDataOrderItems(orderItems: viewModel.orderItems)
    }
    
    //    MARK: Handle add orderItem to Order
 
    func updateDataOrder(order: Order?){
        self.order = order
        guard let orderId = order!.id else { return }
        self.lbPriceOrder?.text = String(order!.grandTotal)
        self.setupOrderView(isHidden: false)
    }
    func updateDataOrderItem(orderItem: OrderItem?){
        self.orderItems.append(orderItem!)
        self.orderItemsTableView.reloadData()
    }
    func updateDataOrderItems(orderItems: [OrderItem]?){
        self.orderItems = orderItems!
        self.orderItemsTableView.reloadData()
    }
    
    
    
    
    func setupOrderView(isHidden: Bool = true){
        btnCancelOrder.isHidden = isHidden
        paymentInfoArea.isHidden = isHidden
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
