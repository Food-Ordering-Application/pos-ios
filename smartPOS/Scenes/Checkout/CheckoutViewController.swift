//
//  CheckoutViewController.swift
//  smartPOS
//
//  Created by I Am Focused on 18/04/2021.
//  Copyright (c) 2021 Clean Swift LLC. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import SkeletonView
import SlideMenuControllerSwift
import SwiftEventBus
import UIKit
protocol CheckoutDisplayLogic: class {
    func displayFetchedMenuItemGroups(viewModel: Checkout.FetchMenuItems.ViewModel)
    func displaySearchedMenuItemGroups(viewModel: Checkout.SearchMenuItems.ViewModel)
    func displayFetchedMenuItemToppings(viewModel: Checkout.FetchMenuItemToppings.ViewModel)
    func displayCreatedOrderItem(viewModel: Checkout.CreateOrderItem.ViewModel)
    func displayManupulatedOrderItem(viewModel: Checkout.ManipulateOrderItemQuantity.ViewModel)
    func displayCreatedOrderAndOrderItems(viewModel: Checkout.CreateOrderAndOrderItems.ViewModel)
    func displayRemovedOrder(viewModel: Checkout.RemoveOrder.ViewModel)
    func displayUpdatedOrder(viewModel: Checkout.UpdateOrder.ViewModel)
}

class CheckoutViewController: UIViewController, CheckoutDisplayLogic, SlideMenuControllerDelegate {
    var searchField: UITextField?
    var interactor: CheckoutBusinessLogic?
    var router: (NSObjectProtocol & CheckoutRoutingLogic & CheckoutDataPassing)?

    @IBOutlet var segmentGroups: UISegmentedControl!

    // MARK: Variables

    var order: Order?
    var orderItems: [OrderItem]?

    var displayedMenuItemGroups: [Checkout.DisplayedMenuItemGroup] = []
    let defaultSegmentIndex = 0

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
        setupNotiEvents()
        setupNavBar()
        fetchMenuItemGroups()
        
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: Fetch MenuItemToppings on popup detail load

extension CheckoutViewController {
    func fetchMenuItemToppings(menuItemId: String) {
        print("onFetchMenuItemToppings", menuItemId)
        let request = Checkout.FetchMenuItemToppings.Request(menuItemId: menuItemId)
        self.interactor?.fetchMenuItemToppings(request: request)
    }

    func displayFetchedMenuItemToppings(viewModel: Checkout.FetchMenuItemToppings.ViewModel) {
        print("displayFetchedMenuItemToppings")
        let toppingGroups = viewModel.toppingGroups
        NotificationCenter.default.post(name: Notification.Name("FetchedMenuItemToppings"), object: toppingGroups)
    }
}

// MARK: Fetch menuItems on screen load

extension CheckoutViewController {
    // MARK: Fetch Data to display in the orders collection view

    func searchMenuItemGroups(keyword: String?) {
        guard let keyword = keyword else {
            self.fetchMenuItemGroups()
            return
        }
        self.view.showGradientSkeleton()
        let request = Checkout.SearchMenuItems.Request(keyword: keyword)
        self.interactor?.searchMenuItemGroups(request: request)
    }

    func displaySearchedMenuItemGroups(viewModel: Checkout.SearchMenuItems.ViewModel) {
        print("displaySearchedMenuItemGroups\(viewModel.displayedMenuItemGroups)")
        self.setupSearchMenuItemGroupDisplay(viewModel: viewModel)
        self.view.hideSkeleton()
    }

    private func setupSearchMenuItemGroupDisplay(viewModel: Checkout.SearchMenuItems.ViewModel) {
        guard viewModel.error == nil else {
            Alert.showUnableToRetrieveDataAlert(on: self)
            return
        }
        self.segmentGroups.removeAllSegments()
        self.displayedMenuItemGroups = viewModel.displayedMenuItemGroups
        if self.displayedMenuItemGroups.count == 0 { return }

        for (index, menuGroup) in self.displayedMenuItemGroups.enumerated() {
            self.segmentGroups.insertSegment(withTitle: menuGroup.name, at: index, animated: true)
        }
        self.onUpdateMenuItem(self.defaultSegmentIndex)
        self.segmentGroups.selectedSegmentIndex = self.defaultSegmentIndex
    }

    func fetchMenuItemGroups() {
        self.view.showGradientSkeleton()
        let restaurantId = APIConfig.getRestaurantId()
        let request = Checkout.FetchMenuItems.Request(restaurantId: restaurantId)
        self.interactor?.fetchMenuItemGroups(request: request)
    }

    func displayFetchedMenuItemGroups(viewModel: Checkout.FetchMenuItems.ViewModel) {
//        print("displayFetchedMenuItems\(viewModel.displayedMenuItemGroups)")
        self.setupMenuItemGroupDisplay(viewModel: viewModel)
        self.view.hideSkeleton()
    }

    private func setupMenuItemGroupDisplay(viewModel: Checkout.FetchMenuItems.ViewModel) {
        guard viewModel.error == nil else {
            Alert.showUnableToRetrieveDataAlert(on: self)
            return
        }
        self.segmentGroups.removeAllSegments()
        self.displayedMenuItemGroups = viewModel.displayedMenuItemGroups
        if self.displayedMenuItemGroups.count == 0 { return }

        for (index, menuGroup) in self.displayedMenuItemGroups.enumerated() {
            self.segmentGroups.insertSegment(withTitle: menuGroup.name, at: index, animated: true)
        }
        self.onUpdateMenuItem(self.defaultSegmentIndex)
        self.segmentGroups.selectedSegmentIndex = self.defaultSegmentIndex
    }

    func onUpdateMenuItem(_ index: Int) {
        if index < self.displayedMenuItemGroups.count {
            let curMenuItems: MenuItems? = self.displayedMenuItemGroups[index].menuItems
            NotificationCenter.default.post(name: Notification.Name("FetchedMenuItems"), object: curMenuItems)
        }
    }

    @IBAction func onChangeSegmentGroups(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        self.onUpdateMenuItem(index)
    }

    private func setupMenuItemsDisplay(viewModel: Checkout.FetchMenuItems.ViewModel) {
        guard viewModel.error == nil else {
            Alert.showUnableToRetrieveDataAlert(on: self)
            return
        }
        NotificationCenter.default.post(name: Notification.Name("FetchedMenuItems"), object: viewModel)
    }
}

// MARK: Create Order and OrderItem

extension CheckoutViewController {
    func createOrderAndOrderItem(orderItem: Checkout.OrderItemFormFields) {
        print("Create OrderItems\(orderItem)")
        let customerId = APIConfig.getMerchantId()
        let restaurantId = APIConfig.getRestaurantId()
        let orderAndOrderItemFormFields = Checkout.OrderAndOrderItemFormFields(orderItem: orderItem, restaurantId: restaurantId, customerId: customerId)
        let request = Checkout.CreateOrderAndOrderItems.Request(orderAndOrderItemFormFields: orderAndOrderItemFormFields)
        self.interactor?.createOrderAndOrderItems(request: request)
    }

    func createOrderItem(_ data: Checkout.OrderItemFormFields?) {
        // MARK: Check already Order to add OrderItem

        guard let orderItem = data else { return }
        guard let order = self.order, let orderId = order.id else {
            self.createOrderAndOrderItem(orderItem: orderItem)
            return
        }

        print("createOrderItem-\(orderItem)")
        let request = Checkout.CreateOrderItem.Request(orderId: orderId, orderItemFormFields: data)
        self.interactor?.createOrderItem(request: request)
    }

    func displayCreatedOrderItem(viewModel: Checkout.CreateOrderItem.ViewModel) {
        print("displayCreatedOrderItem\(viewModel)")
        guard viewModel.error == nil else {
            Alert.showUnableToRetrieveDataAlert(on: self)
            return
        }
        self.updateOrderAndOrderItems(order: viewModel.order, orderItems: viewModel.orderItems)
        NotificationCenter.default.post(name: Notification.Name("CreatedOrderItem"), object: viewModel)
    }

    func displayCreatedOrderAndOrderItems(viewModel: Checkout.CreateOrderAndOrderItems.ViewModel) {
        print("displayCreatedOrderAndOrderItems")
        guard viewModel.error == nil else {
            Alert.showUnableToRetrieveDataAlert(on: self)
            return
        }
        self.updateOrderAndOrderItems(order: viewModel.order, orderItems: viewModel.orderItems)
        NotificationCenter.default.post(name: Notification.Name("CreatedOrderAndOrderItems"), object: viewModel)
    }

    fileprivate func updateOrderAndOrderItems(order: Order?, orderItems: [OrderItem]?) {
        self.order = order
        self.orderItems = orderItems
    }
}

// MARK: Manipulate OrderItem

extension CheckoutViewController {
    func manipulateOrderItem(manipulateOrderItemModel: ManipulateOrderItemModel?) {
        guard let action = manipulateOrderItemModel?.action else {
            Alert.showUnableToRetrieveDataAlert(on: self)
            return
        }
        let orderId = manipulateOrderItemModel?.orderId
        let orderItemId = manipulateOrderItemModel?.orderItemId
        let request = Checkout.ManipulateOrderItemQuantity.Request(action: action, orderId: orderId, orderItemId: orderItemId)
        self.interactor?.manipulateOrderItem(request: request)
    }

    func displayManupulatedOrderItem(viewModel: Checkout.ManipulateOrderItemQuantity.ViewModel) {
        print("displayManupulatedOrderItem\(viewModel)")
        guard viewModel.error == nil else {
            Alert.showUnableToRetrieveDataAlert(on: self)
            return
        }
        self.updateOrderAndOrderItems(order: viewModel.order, orderItems: viewModel.orderItems)
        NotificationCenter.default.post(name: Notification.Name("ManipulatedOrderItem"), object: viewModel)
    }

    func removeOrder(orderId: String) {
        let request = Checkout.RemoveOrder.Request(orderId: orderId)
        self.interactor?.removeOrder(request: request)
    }

    func displayRemovedOrder(viewModel: Checkout.RemoveOrder.ViewModel) {
        print("displayRemovedOrder\(viewModel)")
        guard viewModel.error == nil else {
            Alert.showUnableToRetrieveDataAlert(on: self)
            return
        }
        self.updateOrderAndOrderItems(order: viewModel.order, orderItems: viewModel.orderItems)
        NotificationCenter.default.post(name: Notification.Name("ManipulatedOrderItem"), object: viewModel)
    }

    func updateOrder(order: Order?) {
        let request = Checkout.UpdateOrder.Request(order: order)
        self.interactor?.updateOrder(request: request)
    }

    func displayUpdatedOrder(viewModel: Checkout.UpdateOrder.ViewModel) {
        print("displayUpdatedOrder")
        guard viewModel.error == nil else {
            Alert.showUnableToRetrieveDataAlert(on: self)
            return
        }

        // MARK: BAD CODE DO NOT HARD CODE -> HAVE TO SOLVE THIS PROBLEM

        self.updateOrderAndOrderItems(order: nil, orderItems: [])
        NotificationCenter.default.post(name: Notification.Name("UpdatedOrder"), object: viewModel)
    }
}

// MARK: Setup

private extension CheckoutViewController {
    private func setup() {
        let viewController = self
        let interactor = CheckoutInteractor.shared
        let presenter = CheckoutPresenter()
        let router = CheckoutRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    func setupNotiEvents() {
        // Notifications
        SwiftEventBus.onMainThread(self, name: "ManipulateOrderItem") { notification in
            guard let manipulateOrderItem = notification?.object as? ManipulateOrderItemModel else { return }
            print("didGetNotificationManipulateOrderItem-\(manipulateOrderItem)")
            self.manipulateOrderItem(manipulateOrderItemModel: manipulateOrderItem)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotificationCreateOrderItem(_:)), name: Notification.Name("CreateOrderItem"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotificationFetchMenuItemToppings(_:)), name: Notification.Name("FetchMenuItemToppings"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotificationFetchMenuItems(_:)), name: Notification.Name("FetchMenuItems"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotificationRemoveOrder(_:)), name: Notification.Name("RemoveOrder"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotificationUpdateOrder(_:)), name: Notification.Name("UpdateOrder"), object: nil)
        SwiftEventBus.onMainThread(self, name: "SearchMenuItems") { result in
            let keyword = result?.object as? String
            self.searchMenuItemGroups(keyword: keyword)
        }
    }
    func setupNavBar() {
        navigationItem.title = "Checkout"
        setNavigationBarItem()
        self.view.showAnimatedGradientSkeleton()
    }

    @objc func didGetNotificationFetchMenuItems(_ notification: Notification) {
//        let menuItemId = notification.object as! String
        print("didGetNotificationFetchMenuItems")
        self.view.hideSkeleton()
        self.fetchMenuItemGroups()
    }

    @objc func didGetNotificationFetchMenuItemToppings(_ notification: Notification) {
        let menuItemId = notification.object as! String
        print("didGetNotificationEmitFetchMenuItemToppings-\(menuItemId)")
        self.fetchMenuItemToppings(menuItemId: menuItemId)
    }

    @objc func didGetNotificationRemoveOrder(_ notification: Notification) {
        let orderId = notification.object as! String
        print("didGetNotificationRemoveOrder-\(orderId)")
        self.removeOrder(orderId: orderId)
    }

    @objc func didGetNotificationUpdateOrder(_ notification: Notification) {
        let order = notification.object as? Order
        print("didGetNotificationUpdateOrder")
        self.updateOrder(order: order)
    }

    @objc func didGetNotificationCreateOrderItem(_ notification: Notification) {
        let menuItemAndToppings = notification.object as! MenuItemAndToppings
        print("didGetNotificationCreateOrderItem-\(menuItemAndToppings)")
        let orderItem = self.orderItemConvetter(menuItemAndToppings: menuItemAndToppings)
        self.createOrderItem(orderItem)
    }

    func orderItemConvetter(menuItemAndToppings: MenuItemAndToppings) -> Checkout.OrderItemFormFields {
        let menuItem = menuItemAndToppings.menuItem
        let toppingItems = menuItemAndToppings.toppingItems
        var orderItemToppings: [Checkout.OrderItemToppingFormFields] = []
        for toppingItem in toppingItems ?? [] {
//            var toppingPrice: Double = 0
//            if let menuItemTopping = toppingItem.menuItemToppings.first {
//                toppingPrice = menuItemTopping.customPrice
//            }
            let orderItemTopping = Checkout.OrderItemToppingFormFields(name: toppingItem.name, menuItemToppingId: toppingItem.id, quantity: 1, price: toppingItem.price)
            orderItemToppings.append(orderItemTopping)
        }
        return Checkout.OrderItemFormFields(name: menuItem?.name ?? "No name", menuItemId: menuItem?.id ?? "", price: menuItem?.price ?? 0, quantity: menuItemAndToppings.menuItemQuantity ?? 0, orderItemToppings: orderItemToppings)
    }
}
