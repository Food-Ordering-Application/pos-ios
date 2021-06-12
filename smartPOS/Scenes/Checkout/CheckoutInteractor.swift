//
//  CheckoutInteractor.swift
//  smartPOS
//
//  Created by I Am Focused on 18/04/2021.
//  Copyright (c) 2021 Clean Swift LLC. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import CoreStore
import SwiftEventBus
import UIKit

protocol CheckoutBusinessLogic {
    func fetchMenuItemGroups(request: Checkout.FetchMenuItems.Request)
    func searchMenuItemGroups(request: Checkout.SearchMenuItems.Request)
    func fetchMenuItemToppings(request: Checkout.FetchMenuItemToppings.Request)
    func createOrderItem(request: Checkout.CreateOrderItem.Request)
    func manipulateOrderItem(request: Checkout.ManipulateOrderItemQuantity.Request)
    func createOrderAndOrderItems(request: Checkout.CreateOrderAndOrderItems.Request)
    func removeOrder(request: Checkout.RemoveOrder.Request)
    func updateOrder(request: Checkout.UpdateOrder.Request)
}

protocol CheckoutDataStore {
    var menuItems: [MenuItem]? { get }
    var orderItems: [OrderItem]? { get set }
    var order: Order? { get set }
}

class CheckoutInteractor: CheckoutBusinessLogic, CheckoutDataStore {
    let debugMode = true
    var presenter: CheckoutPresentationLogic?

    // MARK: Properties for saving data during run app

    var order: Order?
    var orderItems: [OrderItem]?
    var orderItemToppings: [OrderItemTopping]?
    var menuItems: [MenuItem]?

    // MARK: For Network

    var worker: CheckoutWorker? = CheckoutWorker()
    var ordersPageWorker: OrdersPageWorker? = OrdersPageWorker()

    // MARK: For CoreDara

    var menuItemsWorker: MenuItemsWorker? = MenuItemsWorker(menuItemsStore: MenuItemsMemStore())
    var ordersWorker: OrdersWorker? = OrdersWorker(ordersStore: OrdersMemStore())

    init() {
        SwiftEventBus.onBackgroundThread(self, name: "POSSyncMenu") { result in
            if NoInternetService.isReachable() {
                guard let menuId = result?.object as? String else { return }
                self.POSSyncMenuItemsDetail(menuId: menuId)
            }
        }

        SwiftEventBus.onBackgroundThread(self, name: "POSSyncOrder") { result in
            if let orderAndOrderItemData = result?.object as? OrderAndOrderItemData {
                self.POSSyncOrderDetail(orderAndOrderItemData: orderAndOrderItemData)
            }
        }
    }
    
    func searchMenuItemGroups(request: Checkout.SearchMenuItems.Request) {
        let keyword = request.keyword
        var response: Checkout.SearchMenuItems.Response!

        menuItemsWorker?.fetchMenuAndMenuGroups(completionHandler: { menuAndMenuItemGroups in
            if let data = menuAndMenuItemGroups {
                response = Checkout.SearchMenuItems.Response(menu: data.menu, menuGroups: data.menuGroups, error: nil)
            }
            else {
                response = Checkout.SearchMenuItems.Response(menu: nil, menuGroups: nil, error: MenuItemErrors.couldNotLoadMenuItems(error: "POS: Not found menuItem."))
            }
            self.presenter?.presentSearchedMenuItemGroups(response: response)
        })
        return

    }
    
    // MARK: Fetch MenuItems

    func fetchMenuItemGroups(request: Checkout.FetchMenuItems.Request) {
        // MARK: Donothing if no the internet

        let restaurantId = request.restaurantId
        var response: Checkout.FetchMenuItems.Response!

        if SyncService.canHandleLocal() {
            menuItemsWorker?.fetchMenuAndMenuGroups(completionHandler: { menuAndMenuItemGroups in
                print("🍀 🍀 🍀 🍀 🍀 🍀 🍀 menuAndMenuItemGroups 🍀 🍀 🍀 🍀 🍀 🍀")
                print(menuAndMenuItemGroups)
                if let data = menuAndMenuItemGroups {
                    response = Checkout.FetchMenuItems.Response(menu: data.menu, menuGroups: data.menuGroups, error: nil)
                }
                else {
                    response = Checkout.FetchMenuItems.Response(menu: nil, menuGroups: nil, error: MenuItemErrors.couldNotLoadMenuItems(error: "POS: Not found menuItem."))
                }
                self.presenter?.presentFetchedMenuItemGroups(response: response)
            })
            return
        }

        worker?.restaurantDataManager.getMenu(restaurantId: restaurantId, false).done { menuRes in
            print("menuRes")

            // MARK: Need to check status code in here 200 -> 300

            print(menuRes.data)
            if menuRes.statusCode == 200 {
                let data = menuRes.data

                MenuItemsMemStore.menu = data.menu
                MenuItemsMemStore.menuItemGroups = data.menuGroups

                let menuId = data.menu.id
                SwiftEventBus.post("POSSyncMenu", sender: menuId)
                response = Checkout.FetchMenuItems.Response(menu: data.menu, menuGroups: data.menuGroups, error: nil)
            }

        }.catch { error in
            print("ERROR-\(error)")
            response = Checkout.FetchMenuItems.Response(menu: nil, menuGroups: nil, error: MenuItemErrors.couldNotLoadMenuItems(error: error.localizedDescription))
        }.finally {
            self.presenter?.presentFetchedMenuItemGroups(response: response)
        }
    }

    // MARK: Fetch MenuItemToppings

    func fetchMenuItemToppings(request: Checkout.FetchMenuItemToppings.Request) {
        let menuItemId = request.menuItemId
        if menuItemId == "" {
            return
        }
        var response: Checkout.FetchMenuItemToppings.Response!

        if SyncService.canHandleLocal() {
            menuItemsWorker?.fetchMenuItemToppings(menuItemId: menuItemId, completionHandler: { toppingGroupsRes in

                if let toppingGroups = toppingGroupsRes {
                    response = Checkout.FetchMenuItemToppings.Response(toppingGroups: toppingGroups)
                }
                else {
                    response = Checkout.FetchMenuItemToppings.Response(toppingGroups: nil, error: MenuItemErrors.couldNotLoadMenuItems(error: "POS: Not found menuItemDetail."))
                }
                self.presenter?.presentFetchedMenuItemToppings(response: response)
            })
            return
        }

        worker?.restaurantDataManager.getMenuItemToppings(menuItemId: menuItemId, debugMode).done { menuItemToppingRes in
            print("menuItemToppingRes")

            // MARK: Need to check status code in here 200 -> 300

            print(menuItemToppingRes.data)
            if menuItemToppingRes.statusCode == 200 {
                let data = menuItemToppingRes.data
                response = Checkout.FetchMenuItemToppings.Response(toppingGroups: data.toppingGroups)
            }
        }.catch { error in
            print("ERROR-\(error)")
            response = Checkout.FetchMenuItemToppings.Response(toppingGroups: nil, error: MenuItemErrors.couldNotLoadMenuItems(error: error.localizedDescription))
        }.finally {
            self.presenter?.presentFetchedMenuItemToppings(response: response)
        }
    }

    func manipulateOrderItem(request: Checkout.ManipulateOrderItemQuantity.Request) {
        print("createOrderItem")
        let orderId = request.orderId
        let orderItemId = request.orderItemId
        let action = request.action
        let handle = ManipulateOrderItemModel(action: action, orderId: orderId ?? "", orderItemId: orderItemId ?? "")
        var response: Checkout.ManipulateOrderItemQuantity.Response!

        if SyncService.canHandleLocal() {
            print("😉 - manipulateOrderItem ")
            ordersWorker?.manipulateOrderItem(handle: handle, orderItemToUpdate: nil) { orderData in
                guard let order = orderData?.order else {
                    response = Checkout.ManipulateOrderItemQuantity.Response(order: nil, error: OrderItemErrors.couldNotLoadCreateOrder(error: "Can not manipulate order."))
                    self.presenter?.presentManipulateddOrderItem(response: response)
                    return
                }
                response = Checkout.ManipulateOrderItemQuantity.Response(order: order, error: nil)
                self.presenter?.presentManipulateddOrderItem(response: response)
            }
            return
        }

        ordersPageWorker?.ordersDataManager.manipulateOrderItemQuantity(action: action, orderId: orderId ?? "", orderItemId: orderItemId ?? "", debugMode).done { orderRes in
            print("manipulateOrderItem")
            print(orderRes.data)
            if orderRes.statusCode >= 200 || orderRes.statusCode <= 300 {
                let data = orderRes.data
                response = Checkout.ManipulateOrderItemQuantity.Response(order: data.order, error: nil)
            }
        }.catch { error in
            print("ERROR-\(error)")
            response = Checkout.ManipulateOrderItemQuantity.Response(order: nil, error: OrderItemErrors.couldNotLoadCreateOrder(error: error.localizedDescription))
        }.finally {
            self.presenter?.presentManipulateddOrderItem(response: response)
        }
    }

    func createOrderItem(request: Checkout.CreateOrderItem.Request) {
        print("createOrderItem")
        let orderId = request.orderId
        var response: Checkout.CreateOrderItem.Response!
        guard let orderItemFormFields = request.orderItemFormFields else {
            response = Checkout.CreateOrderItem.Response(order: nil, error: OrderItemErrors.couldNotLoadCreateOrder(error: "OrderItem is invalid."))
            presenter?.presentCreatedOrderItem(response: response)
            return
        }

        if SyncService.canHandleLocal() {
            print("😉 - createOrderItem ")
            ordersWorker?.createOrderItem(orderId: orderId, orderItemFormFields: orderItemFormFields) { orderData in
                guard let order = orderData?.order else {
                    response = Checkout.CreateOrderItem.Response(order: nil, error: OrderItemErrors.couldNotLoadCreateOrder(error: "Can not create order."))
                    self.presenter?.presentCreatedOrderItem(response: response)
                    return
                }
                response = Checkout.CreateOrderItem.Response(order: order, error: nil)
                self.presenter?.presentCreatedOrderItem(response: response)
            }
            return
        }

        ordersPageWorker?.ordersDataManager.createOrderItem(orderId: orderId ?? "", orderItemFormFields: orderItemFormFields, debugMode).done { orderRes in
            print("orderAndOrderItemFormFields")
            print(orderRes.data)
            if orderRes.statusCode >= 200 || orderRes.statusCode <= 300 {
                let data = orderRes.data
                response = Checkout.CreateOrderItem.Response(order: data.order, error: nil)
            }
        }.catch { error in
            print("ERROR-\(error)")
            response = Checkout.CreateOrderItem.Response(order: nil, error: OrderItemErrors.couldNotLoadCreateOrder(error: error.localizedDescription))
        }.finally {
            self.presenter?.presentCreatedOrderItem(response: response)
        }
    }

    func createOrderAndOrderItems(request: Checkout.CreateOrderAndOrderItems.Request) {
        var response: Checkout.CreateOrderAndOrderItems.Response!

        if SyncService.canHandleLocal() {
            print("😉 - createOrderAndOrderItems")
            let inputData = request.orderAndOrderItemFormFields
            guard let orderItemFormFields = inputData?.orderItem else { return }
            ordersWorker?.createOrderAndOrderItem(orderItemFormFields: orderItemFormFields) { orderData in
                guard let order = orderData?.order else {
                    response = Checkout.CreateOrderAndOrderItems.Response(order: nil, error: OrderItemErrors.couldNotLoadCreateOrder(error: "Can not create order."))
                    self.presenter?.presentCreateOrderAndOrderItem(response: response)
                    return
                }
                response = Checkout.CreateOrderAndOrderItems.Response(order: order, error: nil)
                self.presenter?.presentCreateOrderAndOrderItem(response: response)
            }
            return
        }

        ordersPageWorker?.ordersDataManager.createOrderAndOrderItem(orderAndOrderItemFormFields: request.orderAndOrderItemFormFields!, debugMode).done { orderRes in
            print("orderAndOrderItemFormFields")
            print(orderRes.data)
            if orderRes.statusCode >= 200 || orderRes.statusCode <= 300 {
                let data = orderRes.data
                response = Checkout.CreateOrderAndOrderItems.Response(order: data.order, error: nil)
            }
        }.catch { error in
            print("ERROR-\(error)")
            response = Checkout.CreateOrderAndOrderItems.Response(order: nil, error: OrderItemErrors.couldNotLoadCreateOrder(error: error.localizedDescription))
        }.finally {
            self.presenter?.presentCreateOrderAndOrderItem(response: response)
        }
    }

    func removeOrder(request: Checkout.RemoveOrder.Request) {
        print("removeOrder")
        let orderId = request.orderId
        var response: Checkout.RemoveOrder.Response!

        if SyncService.canHandleLocal() {
            print("😉 - createOrderItem ")
            ordersWorker?.deleteOrder(orderId: orderId ?? "") { _ in
//                guard let order = orderData?.order else {
//                    response = Checkout.RemoveOrder.Response(order: nil, error: OrderItemErrors.couldNotLoadCreateOrder(error: "Can not create order."))
//                    self.presenter?.presentRemovedOrder(response: response)
//                    return
//                }
                response = Checkout.RemoveOrder.Response(order: nil, error: nil)
                self.presenter?.presentRemovedOrder(response: response)
            }
            return
        }
    }

    func updateOrder(request: Checkout.UpdateOrder.Request) {
        print("updateOrder")
        guard let order = request.order else { return }
        var response: Checkout.UpdateOrder.Response!

        if SyncService.canHandleLocal() {
            print("😉 - updateOrder ")
            ordersWorker?.updateOrder(orderToUpdate: order) { orderData in

                guard var order = orderData?.order else {
                    response = Checkout.UpdateOrder.Response(order: nil, error: OrderItemErrors.couldNotLoadCreateOrder(error: "Can not place order."))
                    self.presenter?.presentUpdatedOrder(response: response)
                    return
                }
                order.cashierId = APIConfig.getUserId()
                order.restaurantId = APIConfig.getRestaurantId()
                let orderAndOrderItemData = OrderAndOrderItemData(order: order)
                print("⏰ ⏰ ⏰ ⏰ ⏰ ⏰ ⏰ ⏰ ⏰ ⏰ ⏰ ⏰ ⏰ ⏰")
                print(orderAndOrderItemData)
                print("⏰ ⏰ ⏰ ⏰ ⏰ ⏰ ⏰ ⏰ ⏰ ⏰ ⏰ ⏰ ⏰ ⏰")
                SwiftEventBus.post("POSSyncOrder", sender: orderAndOrderItemData)
                
                response = Checkout.UpdateOrder.Response(order: order, error: nil)
                self.presenter?.presentUpdatedOrder(response: response)
            }
            return
        }
    }
}

// MARK: - Helper function

extension CheckoutInteractor {
    // MARK: Handle syncOrder when update order in local then check isSynced = true if save to server successfull

    // MARK: Need to check internet in here

    /// Because: I want this api do not notification error when can not get api
    func POSSyncOrderDetail(orderAndOrderItemData: OrderAndOrderItemData) {
        var nestedOrder: NestedOrder?
        if NoInternetService.isReachable() {
            ordersPageWorker?.ordersDataManager.syncOrder(orderAndOrderItemData: orderAndOrderItemData, debugMode).done { orderRes in
                print("syncOrder")
                if orderRes.statusCode >= 200 || orderRes.statusCode <= 300 {
                    let data = orderRes.data
                    nestedOrder = data.order
                }
            }.catch { error in
                print("ERROR-\(error)")
            }.finally {
                let seperateOrderAndOderItem = CheckoutPresenter.separateOrderAndOrderItem(nestedOrder: nestedOrder)
                self.ordersWorker?.updateOrder(orderToUpdate: seperateOrderAndOderItem.order!, isSynced: true) { _ in }
            }
        }
    }

    func POSSyncMenuItemsDetail(menuId: String) {
        print("🍀 🍀 POSSyncMenuItemsDetail 🍀 🍀")

        fetchCSMenuItemToppings(menuId: menuId)

        fetchCSToppingItems(menuId: menuId)

        fetchCSToppingGroups(menuId: menuId)
    }

    func fetchCSMenuItemToppings(menuId: String) {
        worker?.restaurantDataManager.getCSMenuItemToppings(menuId: menuId, debugMode).done { csMenuItemToppingRes in
            print("🍀 🍀 csMenuItemToppingRes 🍀 🍀")
            print(csMenuItemToppingRes)
            if csMenuItemToppingRes.statusCode >= 200 || csMenuItemToppingRes.statusCode <= 300 {
                let data = csMenuItemToppingRes.data
                MenuItemsMemStore.menuItemToppings = data?.results ?? []
            }
        }.catch { error in
            print("⁉️ ⁉️ csMenuItemToppingRes ⁉️ ⁉️")
            print(error)
        }.finally {
            // MARK: Handle to save to local
            MenuItemsMemStore.storeMenuItemToppings()
            SwiftEventBus.post("POSSynced")
        }
    }

    func fetchCSToppingItems(menuId: String) {
        worker?.restaurantDataManager.getCSToppingItems(menuId: menuId, debugMode).done { csCSToppingItemRes in
            print("🍀 🍀 csCSToppingItemRes 🍀 🍀")
            print(csCSToppingItemRes)
            if csCSToppingItemRes.statusCode >= 200 || csCSToppingItemRes.statusCode <= 300 {
                let data = csCSToppingItemRes.data
                MenuItemsMemStore.toppingItems = data?.results ?? []
            }
        }.catch { error in
            print("⁉️ ⁉️ csCSToppingItemRes ⁉️ ⁉️")
            print(error)
        }.finally {
            // MARK: Handle to save to local
            MenuItemsMemStore.storeToppingItems()
            SwiftEventBus.post("POSSynced")
        }
    }

    func fetchCSToppingGroups(menuId: String) {
        worker?.restaurantDataManager.getCSToppingGroups(menuId: menuId, debugMode).done { csCSToppingGroupRes in
            print("🍀 🍀 csCSToppingGroupRes 🍀 🍀")
            print(csCSToppingGroupRes)
            if csCSToppingGroupRes.statusCode >= 200 || csCSToppingGroupRes.statusCode <= 300 {
                let data = csCSToppingGroupRes.data
                MenuItemsMemStore.toppingGroups = data?.results ?? []
            }
        }.catch { error in
            print("⁉️ ⁉️ csCSToppingGroupRes ⁉️ ⁉️")
            print(error)
        }.finally {
            // MARK: Handle to save to local
            MenuItemsMemStore.storeToppingGroups()
            SwiftEventBus.post("POSSynced")
        }
    }

    private func buildOrderItemFromOrderItemFormFields(orderId: String?, _ orderItemFormFields: Checkout.OrderItemFormFields) -> OrderItem {
        return OrderItem(id: "", menuItemId: orderItemFormFields.menuItemId, name: orderItemFormFields.name, orderId: orderId, price: orderItemFormFields.price, discount: 0.0, subTotal: orderItemFormFields.price, state: OrderItemStatus.instock, quantity: orderItemFormFields.quantity, note: "buildOrderItemFromOrderItemFormFields")
    }
//    private func nestOrder(order: Order?, orderItems: [OrderItem]?) -> NestedOrder {
//
//
//
//        return NestedOrder(id: order?.id, status: order?.status, cashierId: order?.cashierId, restaurantId: order?.restaurantId, paymentType: order?.paymentType, serviceFee: order?.serviceFee, subTotal: order?.subTotal, grandTotal: order?.grandTotal, itemDiscount: order?.itemDiscount, discount: order?.discount, orderItems: orderItems)
//
//    }
//    private func separateOrderAndOrderItem(nestedOrder: NestedOrder) -> separatedNestedOrder {
//        let order = Order(id: nestedOrder.id, customerId: nestedOrder.customerId!, driverId: nestedOrder.driverId!, subTotal: nestedOrder.subTotal, itemDiscount: nestedOrder.itemDiscount, shippingFee: nestedOrder.shippingFee, serviceFee: nestedOrder.serviceFee, promotionId: "", discount: nestedOrder.discount, grandTotal: nestedOrder.grandTotal ?? 0, paymentMode: PaymentMode.cod, paymentType: PaymentType.cod, status: OrderStatus.checking, note: "", createdAt: nestedOrder.createdAt, deliveredAt: nestedOrder.deliveredAt, updatedAt: nestedOrder.updatedAt)
//
//        var orderItems: [OrderItem]
//        for item in nestedOrder.orderItems! {
//            let orderItem
//        }
//    }
}
