//
//  OrdersPageViewController.swift
//  smartPOS
//
//  Created by I Am Focused on 17/04/2021.
//  Copyright (c) 2021 Clean Swift LLC. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import AVFoundation
import QRCodeReader
import SkeletonView
import SlideMenuControllerSwift
import UIKit

struct ControlStatus {
    let name: String
    let stasus: OrderStatus
    let index: Int
    var lenght: Int = 0
}

protocol OrdersPageDisplayLogic: class {
    func displayOrders(viewModel: OrdersPage.FetchOrders.ViewModel)
    func displaySearchOrders(viewModel: OrdersPage.SearchOrders.ViewModel)
    func displayOrdersByStatus(viewModel: OrdersPage.FetchOrdersByStatus.ViewModel)
    func displayRefreshedOrders(viewModel: OrdersPage.RefreshOrders.ViewModel)
}

class OrdersPageViewController: UIViewController, OrdersPageDisplayLogic {
    var interactor: OrdersPageBusinessLogic?
    var router: (NSObjectProtocol & OrdersPageRoutingLogic & OrdersPageDataPassing)?
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton = true
            $0.preferredStatusBarStyle = .lightContent
            $0.showOverlayView = true
            $0.rectOfInterest = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)

            $0.reader.stopScanningWhenCodeIsFound = false
        }

        return QRCodeReaderViewController(builder: builder)
    }()

    // MARK: - Actions

    @IBOutlet var segmentedControlStatus: UISegmentedControl! {
        didSet {
            segmentedControlStatus.removeAllSegments()
            controlStatuses.forEach { controlStatus in
                let title = "\(controlStatus.name) (\(controlStatus.lenght))"
                self.segmentedControlStatus.insertSegment(withTitle: title, at: controlStatus.index, animated: true)
            }
            segmentedControlStatus.selectedSegmentIndex = currentStatusIndex
        }
    }

    @IBOutlet var ordersConllectionView: UIView!
    @IBOutlet var orderDetailView: UIView!

    // MARK: - Variables

    var controlStatuses: [ControlStatus] = [
        ControlStatus(name: "Chờ xác nhận", stasus: .ordered, index: 0),
        ControlStatus(name: "Đang thực hiện", stasus: .confirmed, index: 1),
        ControlStatus(name: "Đã hoàn thành", stasus: .completed, index: 2),
        ControlStatus(name: "Đã huỷ", stasus: .cancelled, index: 3)
    ]
    var currentStatusIndex = 0

    var displayedOrdersGroups: [OrdersPage.DisplayedOrdersGroup] = []

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchOrders()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarItem()
    }

    func displaySearchOrders(viewModel: OrdersPage.SearchOrders.ViewModel) {
        print("displaySearchOrders")
    }

    func displayOrdersByStatus(viewModel: OrdersPage.FetchOrdersByStatus.ViewModel) {
        print("displayOrdersByStatus")
    }

    func displayRefreshedOrders(viewModel: OrdersPage.RefreshOrders.ViewModel) {
        print("displayRefreshedOrders")
    }

    @IBAction func onChangeSegmentGroup(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        onDisplayOrders(index)
        currentStatusIndex = index
    }

    @IBAction func scanQRCoder(_ sender: Any) {
        guard checkScanPermissions() else { return }

        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate = self

        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")
            }
        }

        present(readerVC, animated: true, completion: nil)
    }

    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController

            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { _ in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))

                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }

            present(alert, animated: true, completion: nil)

            return false
        }
    }
}

// MARK: Fetch orders on screen load

extension OrdersPageViewController {
    // MARK: Fetch Data to display in the orders collection view

    func fetchOrders() {
        view.showAnimatedGradientSkeleton()
        let restaurantId = APIConfig.getRestaurantId()
        let query = "SALE"
        let pageNumber = 1
        let request = OrdersPage.FetchOrders.Request(restaurantId: restaurantId, query: query, pageNumber: pageNumber)
        interactor?.fetchOrders(request: request)
    }

    func displayOrders(viewModel: OrdersPage.FetchOrders.ViewModel) {
        view.hideSkeleton()

        // MARK: Need to do this func after display orders on collection view

        setupOrdersDisplay(viewModel: viewModel)
        print("displayOrders")
    }

    private func setupOrdersDisplay(viewModel: OrdersPage.FetchOrders.ViewModel) {
        guard viewModel.error == nil else {
            Alert.showUnableToRetrieveDataAlert(on: self)
            return
        }
        let ordersGroups = viewModel.displayedOrdersGroups
        if ordersGroups.count == 0 { return }
        var groups: [OrdersPage.DisplayedOrdersGroup] = []
        controlStatuses.forEach { controlStatus in
            let status = controlStatus.stasus
            // MARK: Merge some status of order to one tab is completed
            if status == .completed {
                guard var readyGroup = ordersGroups.filter({ group -> Bool in
                    group.status == OrderStatus.ready.rawValue
                }).first else { return }
                let completedGroup = ordersGroups.filter { group -> Bool in
                    group.status == OrderStatus.completed.rawValue
                }.first
                let completedOrders = completedGroup?.orders
                readyGroup.orders?.append(contentsOf: completedOrders ?? [])
                readyGroup.length = readyGroup.orders?.count
                groups.append(readyGroup)
                return
            }
            if let group = ordersGroups.filter({ group -> Bool in
                group.status == status.rawValue
            }).first {
                groups.append(group)
                return
            }
            let tempGroup = OrdersPage.DisplayedOrdersGroup(status: controlStatus.stasus.rawValue, length: 0, orders: [])
            groups.append(tempGroup)
        }
        displayedOrdersGroups = groups

        for (index, orderGroup) in displayedOrdersGroups.enumerated() {
            if index < controlStatuses.count {
                let controlStatus = controlStatuses[index]
                let title = "\(controlStatus.name) (\(orderGroup.orders!.count))"
                segmentedControlStatus.setTitle(title, forSegmentAt: controlStatus.index)
            }
        }
        onDisplayOrders(currentStatusIndex)
        segmentedControlStatus.selectedSegmentIndex = currentStatusIndex
    }

    func onDisplayOrders(_ index: Int) {
        var curOrders: Orders? = []
        if index < displayedOrdersGroups.count {
            curOrders = displayedOrdersGroups[index].orders
        }
        NotificationCenter.default.post(name: Notification.Name("FetchedOrders"), object: curOrders)
    }
}

// MARK: Setup

private extension OrdersPageViewController {
    private func setup() {
        let viewController = self
        let interactor = OrdersPageInteractor()
        let presenter = OrdersPagePresenter()
        let router = OrdersPageRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor

        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotificationFetchOrders(_:)), name: Notification.Name("FetchOrders"), object: nil)
    }

    @objc func didGetNotificationFetchOrders(_ notification: Notification) {
        fetchOrders()
    }
}

// MARK: - QRCodeReader Delegate Methods

extension OrdersPageViewController: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()

        dismiss(animated: true) { [weak self] in
//            let alert = UIAlertController(
//                title: "QRCodeReader",
//                message: String(format: "%@ (of type %@)", result.value, result.metadataType),
//                preferredStyle: .alert
//            )
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//
//            self?.present(alert, animated: true, completion: nil)
            let orderId = result.value
            NotificationCenter.default.post(name: Notification.Name("OrderDetail"), object: orderId)
        }
    }

    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capture to: \(newCaptureDevice.device.localizedName)")
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
}
