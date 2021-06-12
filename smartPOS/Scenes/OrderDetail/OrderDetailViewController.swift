//
//  OrderDetailViewController.swift
//  smartPOS
//
//  Created by I Am Focused on 18/04/2021.
//  Copyright (c) 2021 Clean Swift LLC. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import EmptyDataSet_Swift
import Loady
import UIKit

protocol OrderDetailDisplayLogic: class {
    func displayOrder(viewModel: OrderDetail.GetOrder.ViewModel)
    func displayConfirmedOrder(viewModel: OrderDetail.ConfirmOrder.ViewModel)
    func displayRejectedOrder(viewModel: OrderDetail.RejectOrder.ViewModel)
    func displayCompletedOrder(viewModel: OrderDetail.CompleteOrder.ViewModel)
}

class OrderDetailViewController: UIViewController, OrderDetailDisplayLogic, EmptyDataSetSource, EmptyDataSetDelegate, UIPopoverPresentationControllerDelegate, RejectionViewControllerDelegate {
    var interactor: OrderDetailBusinessLogic?
    var router: (NSObjectProtocol & OrderDetailRoutingLogic & OrderDetailDataPassing)?

    @IBOutlet var btnAreaView: UIStackView!
    @IBOutlet var orderItemsTableView: UITableView!
    @IBOutlet var btnAccept: LoadyButton! {
        didSet {
            self.btnAccept.layer.cornerRadius = 8
            self.btnAccept.setAnimation(LoadyAnimationType.indicator(with: .init(indicatorViewStyle: .light)))
        }
    }

    @IBOutlet var btnReject: LoadyButton! {
        didSet {
            self.btnReject.layer.borderWidth = 1
            self.btnReject.layer.borderColor = #colorLiteral(red: 0.8506677372, green: 0.2256608047, blue: 0.1839731823, alpha: 1)

            self.btnReject.layer.shadowPath = UIBezierPath(rect: self.btnReject.bounds).cgPath
            self.btnReject.setAnimation(LoadyAnimationType.topLine())
        }
    }

    @IBOutlet var btnComplete: LoadyButton! {
        didSet {
            self.btnComplete.layer.cornerRadius = 8
            self.btnComplete.setAnimation(LoadyAnimationType.indicator(with: .init(indicatorViewStyle: .light)))
            self.btnComplete.isHidden = true
        }
    }

    @IBOutlet var statusAreaView: UIView! {
        didSet {
            self.statusAreaView.isHidden = true
        }
    }

    @IBOutlet var addressAreaView: UIView! {
        didSet {
            self.addressAreaView.isHidden = true
        }
    }

    @IBOutlet var noteAreaView: UIView! {
        didSet {
            self.noteAreaView.isHidden = true
        }
    }

    @IBOutlet var timeAreaView: UIView! {
        didSet {
            self.timeAreaView.isHidden = true
        }
    }

    @IBOutlet var paymentAreaView: UIStackView! {
        didSet {
            self.paymentAreaView.isHidden = true
        }
    }

    @IBOutlet var lbOrderId: UILabel!

    @IBOutlet var lbOrderStatus: UILabel!
    @IBOutlet var lbTotal: UILabel!
    @IBOutlet var lbNote: UILabel!
    @IBOutlet var lbDeliveryAddress: UILabel!
    @IBOutlet var lbDriverAvailabel: UILabel!

    var order: Order?
    var orderItems: [OrderItem] = []
    var rejectionData: RejectionDataModel?

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLayout()
        self.setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.setupLayout()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RejectionViewController" {
            if let controller = segue.destination as? RejectionViewController {
                controller.orderItems = self.orderItems
                controller.delegate = self
                controller.popoverPresentationController?.delegate = self
            }
        }
    }

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }

    func rejectionData(data: RejectionDataModel) {
        self.rejectionData = data
        self.setupReadyRejectOrder()
    }

    func setupReadyRejectOrder() {
        self.btnReject.tag = 1
        self.btnAccept.isHidden = true
    }

    @IBAction func confirmOrder(_ sender: Any) {
        print("confirm my order pls")
        if let orderId = order?.id {
            self.btnAccept.startLoading()
            self.confirmOrder(for: orderId)
        }
    }

    @IBAction func rejectOrder(_ sender: UIButton) {
        print("reject my order pls")
        if sender.tag == 1 {
            if let orderId = order?.id {
                self.btnReject.startLoading()
                self.rejectOrder(for: orderId, data: self.rejectionData)
            }
            return
        }

        self.performSegue(withIdentifier: "RejectionViewController", sender: self.orderItems)
    }

    @IBAction func completeOrder(_ sender: Any) {
        print("complete my order pls")
        if let orderId = order?.id {
            self.btnComplete.startLoading()
            self.completeOrder(for: orderId)
            return
        }
        self.btnReject.startLoading()
    }
}

// MARK: Display order

extension OrderDetailViewController {
    // MARK: Do something

    func getOrder(for id: String) {
        let request = OrderDetail.GetOrder.Request(id: id)
        self.interactor?.getOrder(request: request)
    }

    func displayOrder(viewModel: OrderDetail.GetOrder.ViewModel) {
        // nameTextField.text = viewModel.name
        self.setupOrderDisplay(viewModel: viewModel)
        print("displayOrder\(viewModel)")
        view.hideSkeleton()
    }

    private func setupOrderDisplay(viewModel: OrderDetail.GetOrder.ViewModel) {
        print("setupOrderDisplay")
        guard viewModel.error == nil else {
            Alert.showUnableToRetrieveDataAlert(on: self)
            return
        }
        self.updateOrderAndOrderItems(order: viewModel.order, orderItems: viewModel.orderItems)
    }

    fileprivate func updateOrderAndOrderItems(order: Order?, orderItems: [OrderItem]?) {
        self.updateOrder(order: order)
        self.updateOrderItems(orderItems: orderItems)
    }

    fileprivate func updateOrder(order: Order?) {
        self.order = order
        guard let order = order else {
            self.setupOrderView()
            return
        }
        self.setupOrderView(isHidden: false)
        self.lbOrderId!.text = order.id?.components(separatedBy: "-").first ?? "_"
        self.lbOrderStatus!.text = order.status.map { $0.rawValue }
        self.lbTotal!.text = String(format: "%.0f", order.grandTotal ?? 0.0).currency()
        self.lbDeliveryAddress!.text = "Chưa có địa chỉ giao hàng"
        self.lbDriverAvailabel!.text = "Chưa có tài xế hoạt động gần đây"

        /// Need to show or hide note area in here when having data
        self.noteAreaView.isHidden = true
        self.btnAreaView.isHidden = false
        self.btnComplete.isHidden = true
        self.timeAreaView.isHidden = true
        if let note = order.note, note != "" {
            self.noteAreaView.isHidden = false
            self.lbNote.text = note
        }
        if let deliver = order.delivery {
            self.lbDeliveryAddress!.text = deliver.customerAddress
        }

        if let status = order.status {
            switch status {
            case .ordered:
                self.btnAreaView.isHidden = false
                self.btnAccept.isHidden = false
                self.btnComplete.isHidden = true
            case .confirmed:
                self.btnAreaView.isHidden = true
                self.btnComplete.isHidden = false
            default:
                self.btnAreaView.isHidden = true
                self.btnComplete.isHidden = true
            }
        }
    }

    func setupOrderView(isHidden: Bool = true) {
        self.statusAreaView.isHidden = isHidden
        self.addressAreaView.isHidden = isHidden
        self.noteAreaView.isHidden = isHidden
        self.timeAreaView.isHidden = isHidden
        self.paymentAreaView.isHidden = isHidden
    }

    fileprivate func updateOrderItems(orderItems: [OrderItem]?) {
        self.orderItems = orderItems ?? []
        self.orderItemsTableView.reloadData()
    }
}

// MARK: Display confirmed order

extension OrderDetailViewController {
    func confirmOrder(for id: String) {
        let request = OrderDetail.ConfirmOrder.Request(id: id)
        self.interactor?.confirmOrder(request: request)
    }

    func displayConfirmedOrder(viewModel: OrderDetail.ConfirmOrder.ViewModel) {
        if self.btnAccept.loadingIsShowing() {
            self.btnAccept.stopLoading()
        }
        guard viewModel.error == nil else {
            Alert.showUnableToRetrieveDataAlert(on: self)
            return
        }

        // MARK: Update Status and Hide Button Action

        self.updateConfirmedOrder()
    }

    func updateConfirmedOrder() {
        self.btnAreaView.isHidden = true
        self.lbOrderStatus!.text = "CONFIRMED"
        self.btnComplete.isHidden = false
    }
}

// MARK: Display rejected order

extension OrderDetailViewController {
    func rejectOrder(for id: String, data: RejectionDataModel?) {
        let request = OrderDetail.RejectOrder.Request(id: id, orderItemIds: data?.orderItemIds, cashierNote: data?.note)
        self.interactor?.rejectOrder(request: request)
    }

    func displayRejectedOrder(viewModel: OrderDetail.RejectOrder.ViewModel) {
        // MARK: Update Status and Hide Button Action

        if self.btnReject.loadingIsShowing() {
            self.btnReject.stopLoading()
        }
        guard viewModel.error == nil else {
            Alert.showUnableToRetrieveDataAlert(on: self)
            self.btnReject.tag = 0
            self.btnAccept.isHidden = false
            return
        }

        // MARK: Update Status and Hide Button Action

        self.updateRejectedOrder()
    }

    func updateRejectedOrder() {
        self.btnAreaView.isHidden = true
        self.btnAccept.isHidden = false
    }
}

// MARK: Display rejected order

extension OrderDetailViewController {
    func completeOrder(for id: String) {
        let request = OrderDetail.CompleteOrder.Request(id: id)
        self.interactor?.completeOrder(request: request)
    }

    func displayCompletedOrder(viewModel: OrderDetail.CompleteOrder.ViewModel) {
        // MARK: Update Status and Hide Button Action

        if self.btnComplete.loadingIsShowing() {
            self.btnComplete.stopLoading()
        }
        guard viewModel.error == nil else {
            Alert.showUnableToRetrieveDataAlert(on: self)
            return
        }

        // MARK: Update Status and Hide Button Action

        self.updateCompletedOrder()
    }

    func updateCompletedOrder() {
        self.btnComplete.isHidden = true
    }
}

// MARK: Setup Notification to receive data from Another View Controller

extension OrderDetailViewController {
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotificationOrderDetail(_:)), name: Notification.Name("OrderDetail"), object: nil)
    }

    @objc func didGetNotificationOrderDetail(_ notification: Notification) {
        view.showSkeleton()
        let orderId = notification.object as! String?
        self.getOrder(for: orderId!)
    }
}

// MARK: Setting DataSorce And Delegate for TableView

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
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
}

// MARK: Style Button

extension OrderDetailViewController {
    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = OrderDetailInteractor()
        let presenter = OrderDetailPresenter()
        let router = OrderDetailRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        self.setupNotification()
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
