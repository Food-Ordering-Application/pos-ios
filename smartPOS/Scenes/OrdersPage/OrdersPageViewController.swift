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
        ControlStatus(name: "Chờ xác nhận", stasus: .draft, index: 0),
        ControlStatus(name: "Đang thực hiện", stasus: .ordered, index: 1),
        ControlStatus(name: "Đã hoàn thành", stasus: .complete, index: 2),
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
            
        displayedOrdersGroups = viewModel.displayedOrdersGroups
        if displayedOrdersGroups.count == 0 { return }
            
        displayedOrdersGroups.sort { (firstGroup, secondGroup) -> Bool in
            let firstIndex = controlStatuses.filter { $0.stasus.rawValue == firstGroup.status }.first?.index ?? displayedOrdersGroups.count - 1
            let secondIndex = controlStatuses.filter { $0.stasus.rawValue == secondGroup.status }.first?.index ?? displayedOrdersGroups.count - 1
            return firstIndex < secondIndex
        }
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
