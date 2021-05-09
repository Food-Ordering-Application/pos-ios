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
import UIKit

protocol CheckoutDisplayLogic: class {
    func displayFetchedMenuItemGroups(viewModel: Checkout.FetchMenuItems.ViewModel)
    func displayFetchedMenuItemToppings(viewModel: Checkout.FetchMenuItemToppings.ViewModel)
    func displayCreatedOrderItem(viewModel: Checkout.CreateOrderItem.ViewModel)
    func displayManupulatedOrderItem(viewModel: Checkout.ManipulateOrderItemQuantity.ViewModel)
    func displayCreatedOrderAndOrderItems(viewModel: Checkout.CreateOrderAndOrderItems.ViewModel)
}

class CheckoutViewController: UIViewController, CheckoutDisplayLogic, SlideMenuControllerDelegate {
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

    func fetchMenuItemGroups() {
        let restaurantId = APIConfig.restaurantId
        let request = Checkout.FetchMenuItems.Request(restaurantId: restaurantId)
        self.interactor?.fetchMenuItemGroups(request: request)
    }

    func displayFetchedMenuItemGroups(viewModel: Checkout.FetchMenuItems.ViewModel) {
        print("displayFetchedMenuItems\(viewModel.displayedMenuItemGroups)")
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
        let curMenuItems: MenuItems? = self.displayedMenuItemGroups[index].menuItems
        NotificationCenter.default.post(name: Notification.Name("FetchMenuItems"), object: curMenuItems)
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
        NotificationCenter.default.post(name: Notification.Name("FetchMenuItems"), object: viewModel)
    }
}

// MARK: Create Order and OrderItem

extension CheckoutViewController {
    func createOrderAndOrderItem(orderItem: Checkout.OrderItemFormFields) {
        print("Create OrderItems\(orderItem)")
        let customerId = APIConfig.customerId
        let restaurantId = APIConfig.restaurantId
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
}

// MARK: Setup

private extension CheckoutViewController {
    private func setup() {
        let viewController = self
        let interactor = CheckoutInteractor()
        let presenter = CheckoutPresenter()
        let router = CheckoutRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor

        // Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotificationManipulateOrderItem(_:)), name: Notification.Name("ManipulateOrderItem"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotificationCreateOrderItem(_:)), name: Notification.Name("CreateOrderItem"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didGetNotificationFetchMenuItemToppings(_:)), name: Notification.Name("FetchMenuItemToppings"), object: nil)
    }

    func setupNavBar() {
        navigationItem.title = "Checkout"
        setNavigationBarItem()
        self.view.showAnimatedGradientSkeleton()
    }

    @objc func didGetNotificationFetchMenuItemToppings(_ notification: Notification) {
        let menuItemId = notification.object as! String
        print("didGetNotificationEmitFetchMenuItemToppings-\(menuItemId)")
        self.fetchMenuItemToppings(menuItemId: menuItemId)
    }
    @objc func didGetNotificationManipulateOrderItem(_ notification: Notification) {
        let manipulateOrderItem = notification.object as! ManipulateOrderItemModel
        print("didGetNotificationManipulateOrderItem-\(manipulateOrderItem)")
        self.manipulateOrderItem(manipulateOrderItemModel: manipulateOrderItem)
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
            var toppingPrice: Double = 0
            if let menuItemTopping = toppingItem.menuItemToppings.first {
                toppingPrice = menuItemTopping.customPrice
            }
            let orderItemTopping = Checkout.OrderItemToppingFormFields(menuItemToppingId: toppingItem.id, quantity: 1, price: toppingPrice)
            orderItemToppings.append(orderItemTopping)
        }
        return Checkout.OrderItemFormFields(menuItemId: menuItem?.id ?? "", price: menuItem?.price ?? 0, quantity: menuItemAndToppings.menuItemQuantity ?? 0, orderItemToppings: orderItemToppings)
    }
}
