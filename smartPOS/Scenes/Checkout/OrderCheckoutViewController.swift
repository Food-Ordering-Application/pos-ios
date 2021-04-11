//
//  OrderCheckoutViewController.swift
//  smartPOS
//
//  Created by I Am Focused on 07/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import UIKit

class OrderCheckoutViewController: UIViewController {
    @IBOutlet var orderItemsTableView: UITableView!
    var orderItems: [OrderItem] = [
        OrderItem(name: "OrderItem1"),
        OrderItem(name: "OrderItem2"),
        OrderItem(name: "OrderItem3"),
        OrderItem(name: "OrderItem4"),
        OrderItem(name: "OrderItem5")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register tableView for xib cell
        setupTableView()
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
    func setupTableView(){
        self.orderItemsTableView.separatorStyle = .none
        self.orderItemsTableView.register(OrderItemTableViewCell.nib, forCellReuseIdentifier: OrderItemTableViewCell.identifier)
    }
    
//    func addLeftBorder() {
//        let thickness: CGFloat = 2.0
//
//        let leftBorder = CALayer()
//        leftBorder.frame = CGRect(x: 0.0, y: 0.0, width: thickness, height: self.mainView.frame.size.height)
//        leftBorder.backgroundColor = UIColor.orange.withAlphaComponent(0.4).cgColor
//
//    }
}

extension OrderCheckoutViewController: UITableViewDelegate {
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
}

extension OrderCheckoutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .checkout, .main, .java, .setting, .nonMenu:
//                let cell = MenuItemTableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: MenuItemTableViewCell.identifier)
                guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderItemTableViewCell.identifier, for: indexPath) as? OrderItemTableViewCell else { fatalError("xib doesn't exist") }

                cell.setData(self.orderItems[indexPath.row])
                // Highlighted color
                let myCustomSelectionColorView = UIView()
                myCustomSelectionColorView.backgroundColor = #colorLiteral(red: 0.9333369732, green: 0.4588472247, blue: 0.2666652799, alpha: 0.161368649)
                myCustomSelectionColorView.layer.cornerRadius = 15
                cell.selectedBackgroundView = myCustomSelectionColorView
                return cell
            }
        }
        return UITableViewCell()
    }
}
