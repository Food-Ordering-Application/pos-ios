//
//  DeliveryOrderDetailViewController.swift
//  smartPOS
//
//  Created by I Am Focused on 15/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//
import UIKit
import EmptyDataSet_Swift


class DeliveryOrderDetailViewController: UIViewController,  EmptyDataSetSource, EmptyDataSetDelegate {
    @IBOutlet weak var orderItemsTableView: UITableView!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    
    var orderItems: [OrderItem] = [ ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        self.setupButton()
        self.setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.setupLayout()
    }
    
// MARK: Style Button

    func setupButton() {
        self.btnReject.layer.borderWidth = 1
        self.btnReject.layer.borderColor = #colorLiteral(red: 0.8506677372, green: 0.2256608047, blue: 0.1839731823, alpha: 1)
        self.btnReject.layer.cornerRadius = 8
        self.btnReject.layer.shadowPath = UIBezierPath(rect: self.btnReject.bounds).cgPath
    }
    
    func setupLayout() {
        self.view.layer.borderWidth = 1
        self.view.layer.borderColor = #colorLiteral(red: 0.9333369732, green: 0.4588472247, blue: 0.2666652799, alpha: 1)
        self.view.layer.cornerRadius = 15
        self.view.layer.shadowPath = UIBezierPath(rect: self.view.bounds).cgPath
//        self.view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
//        self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
    }
    
// MARK: Register tableView for xib cell
    func setupTableView(){
        self.orderItemsTableView.separatorStyle = .none
        self.orderItemsTableView.register(OrderItemTableViewCell.nib, forCellReuseIdentifier: OrderItemTableViewCell.identifier)
        self.orderItemsTableView.emptyDataSetView { [weak self] view in
            if let `self` = self {
                view.titleLabelString(NSAttributedString.init(string:"Empty"))
            }
        }
    }
}


// MARK: Setting DataSorce And Delegate for TableView
extension DeliveryOrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
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

