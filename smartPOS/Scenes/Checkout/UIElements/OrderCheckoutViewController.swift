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

    var orderItems: [OrderItem] = [
//        OrderItem(name: "Salad sốt chua cayy"),
//        OrderItem(name: "Salad sốt chua cayy"),
//        OrderItem(name: "Salad sốt chua cayy"),
//        OrderItem(name: "Salad sốt chua cayy"),
//        OrderItem(name: "Salad sốt chua cayy"),
//        OrderItem(name: "Salad sốt chua cayy"),
//        OrderItem(name: "Salad sốt chua cayy"),
//        OrderItem(name: "Salad sốt chua cayy"),
//        OrderItem(name: "Salad sốt chua cayy"),
//        OrderItem(name: "Salad sốt chua cayy"),
//        OrderItem(name: "Salad sốt chua cayy"),
//        OrderItem(name: "Salad sốt chua cayy"),
//        OrderItem(name: "Salad sốt chua cayy"),
//        OrderItem(name: "Salad sốt chua cayy")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.borderWidth = 1
        self.view.layer.borderColor = #colorLiteral(red: 0.9333369732, green: 0.4588472247, blue: 0.2666652799, alpha: 1)
        self.view.layer.cornerRadius = 15
        self.view.layer.shadowPath = UIBezierPath(rect: self.view.bounds).cgPath
//        self.view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
//        self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.1)

        self.setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.setupLayout()
    } /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

    func setupLayout() {
//        self.addLeftBorder()
    }

    // MARK: Register tableView for xib cell

    func setupTableView() {
        self.orderItemsTableView.separatorStyle = .none
        self.orderItemsTableView.register(OrderItemTableViewCell.nib, forCellReuseIdentifier: OrderItemTableViewCell.identifier)
        self.orderItemsTableView.emptyDataSetView { [weak self] view in
            if let `self` = self {
                view.titleLabelString(NSAttributedString.init(string:"Empty!"))
            }
        }
    }

//    func addLeftBorder() {
//        let thickness: CGFloat = 2.0
//
//        let leftBorder = CALayer()
//        leftBorder.frame = CGRect(x: 0.0, y: 0.0, width: thickness, height: self.mainView.frame.size.height)
//        leftBorder.backgroundColor = UIColor.orange.withAlphaComponent(0.4).cgColor
//
//    }

//    MARK: Handle add orderItem to Order

    fileprivate func onAddOrderItem() {
        let orderItem = OrderItem(id: "0", menuItemId: "menuItemId-123", orderId: "orderId-123", price: 99999.0, discount: 0.0, quantity: 1, note: "Không đường, ít đá")
        self.orderItems.append(orderItem)

        // Update data in tableView
        self.orderItemsTableView.reloadData()
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
