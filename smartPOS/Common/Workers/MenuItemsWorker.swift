//
//  MenuItemsWorker.swift
//  smartPOS
//
//  Created by I Am Focused on 22/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation

class MenuItemsWorker {
    var menuItemsStore: MenuItemsStoreProtocol

    init(menuItemsStore: MenuItemsStoreProtocol) {
        self.menuItemsStore = menuItemsStore
    }

    
    func fetchMenuAndMenuGroups(completionHandler: @escaping (MenuAndMenuGroups?) -> Void) {
        menuItemsStore.fetchMenuAndMenuGroups { (menuAndMenuGroups: () throws -> MenuAndMenuGroups?) -> Void in
            do {
                let menuAndMenuGroups = try menuAndMenuGroups()
                DispatchQueue.main.async {
                    completionHandler(menuAndMenuGroups)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
    func fetchMenuItemToppings(menuItemId: String, completionHandler: @escaping ([ToppingGroup]?) -> Void ){
        menuItemsStore.fetchMenuItemToppings(menuItemId: menuItemId) { (toppingGroups: () throws -> [ToppingGroup]?) in
            do {
                let toppingGroups = try toppingGroups()
                DispatchQueue.main.async {
                    completionHandler(toppingGroups)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
//    func fetchMenuItemToppings(menuItemId: String, completionHandler: @escaping (() throws -> MenuItem?) -> Void)
    func fetchMenuItems(completionHandler: @escaping ([MenuItem]) -> Void) {
        menuItemsStore.fetchMenuItems { (menuItems: () throws -> [MenuItem]) -> Void in
            do {
                let menuItems = try menuItems()
                DispatchQueue.main.async {
                    completionHandler(menuItems)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler([])
                }
            }
        }
    }

    func createMenuItem(menuItemToCreate: MenuItem, completionHandler: @escaping (MenuItem?) -> Void) {
        menuItemsStore.createMenuItem(menuItemToCreate: menuItemToCreate) { (menuItem: () throws -> MenuItem?) -> Void in
            do {
                let menuItem = try menuItem()
                DispatchQueue.main.async {
                    completionHandler(menuItem)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }

    func updateMenuItem(menuItemToUpdate: MenuItem, completionHandler: @escaping (MenuItem?) -> Void) {
        menuItemsStore.updateMenuItem(menuItemToUpdate: menuItemToUpdate) { (menuItem: () throws -> MenuItem?) in
            do {
                let menuItem = try menuItem()
                DispatchQueue.main.async {
                    completionHandler(menuItem)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
}

// MARK: - MenuItems store API

protocol MenuItemsStoreProtocol {
    // MARK: CRUD operations - Inner closure

    func fetchMenuAndMenuGroups(completionHandler: @escaping (() throws -> MenuAndMenuGroups?) -> Void)
    func fetchMenuItems(completionHandler: @escaping (() throws -> [MenuItem]) -> Void)
    func fetchMenuItemToppings(menuItemId: String, completionHandler: @escaping (() throws -> [ToppingGroup]?) -> Void)
    func createMenuItem(menuItemToCreate: MenuItem, completionHandler: @escaping (() throws -> MenuItem?) -> Void)
    func updateMenuItem(menuItemToUpdate: MenuItem, completionHandler: @escaping (() throws -> MenuItem?) -> Void)
    func deleteMenuItem(id: String, completionHandler: @escaping (() throws -> MenuItem?) -> Void)
}

protocol MenuItemsStoreUtilityProtocol {}

extension MenuItemsStoreUtilityProtocol {
    func generateMenuItemID(menuItem: inout MenuItem) {
        guard menuItem.id == nil else { return }
        menuItem.id = "\(arc4random())"
    }

    func calculateMenuItemTotal(menuItem: inout MenuItem) {
//    guard menuItem.grandTotal == NSDecimalNumber.notANumber else { return }
//    menuItem.grandTotal = Int32(truncating: NSDecimalNumber.one)
    }
}
struct MenuAndMenuGroups {
    var menu: Menu?
    var menuGroups: MenuGroups?
}


enum MenuItemsStoreResult<U> {
    case Success(result: U)
    case Failure(error: MenuItemsStoreError)
}

// MARK: - MenuItems store CRUD operation errors

enum MenuItemsStoreError: Equatable, Error {
    case CannotFetch(String)
    case CannotCreate(String)
    case CannotUpdate(String)
    case CannotDelete(String)
}

func ==(lhs: MenuItemsStoreError, rhs: MenuItemsStoreError) -> Bool {
    switch (lhs, rhs) {
    case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
    case (.CannotCreate(let a), .CannotCreate(let b)) where a == b: return true
    case (.CannotUpdate(let a), .CannotUpdate(let b)) where a == b: return true
    case (.CannotDelete(let a), .CannotDelete(let b)) where a == b: return true
    default: return false
    }
}
