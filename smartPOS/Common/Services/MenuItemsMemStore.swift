//
//  MenuItemsMemStore.swift
//  smartPOS
//
//  Created by I Am Focused on 22/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import CoreStore
import Foundation
import SwiftEventBus

class MenuItemsMemStore: MenuItemsStoreProtocol, MenuItemsStoreUtilityProtocol {
    // MARK: - Data

    static var menu: Menu?
    static var menuItems: [MenuItem] = []
    static var menuItemGroups: MenuGroups? /// its mean MenuItemGroup
    
    static var menuItemToppings: [MenuItemToppingData]?
    static var toppingItems: [ToppingItemData]?
    static var toppingGroups: [ToppingGroupData]?
    
    init() {
        // MARK: This is sync for menuItem and groups

        SwiftEventBus.onBackgroundThread(self, name: "POSSyncMenuItem") { _ in
            if NoInternetService.isReachable(), let menu = MenuItemsMemStore.menu, let menuItemGroups = MenuItemsMemStore.menuItemGroups {
                print("🆑 🆑 🆑 🆑 🆑 🆑 🆑 🆑 🆑 🆑 🆑 🆑 🆑 🆑 🆑 🆑 🆑 🆑")
                CSWorker.clearStoreLocalMenu()
            }
//            let queue = DispatchQueue.global(qos: .background) // or some higher QOS level
//            // Do somthing after 10.5 seconds
//            queue.asyncAfter(deadline: .now() + 6) {
//                // your task code here
//                DispatchQueue.main.async {
//                    print("Hello Iam Sync Sync Sync")
//                    MenuItemsMemStore.storeMenuItems()
//                }
//            }
            MenuItemsMemStore.storeMenuItems()
            SwiftEventBus.post("POSSynced")
        }
    }
    
    static func storeMenuItems() {
        if let menu = MenuItemsMemStore.menu, let menuItemGroups = MenuItemsMemStore.menuItemGroups {
            // MARK: Save data to local
            CSWorker.storeLocal(menu: menu, menuGroups: menuItemGroups)
        }
    }

    static func storeMenuItemToppings() {
        if let menuItemToppings = MenuItemsMemStore.menuItemToppings {
            // MARK: Save MenuItemToppings to local

            CSWorker.storeLocalMenuItemToppings(menuItemToppings: menuItemToppings)
        }
    }

    static func storeToppingItems() {
        if let toppingItems = MenuItemsMemStore.toppingItems {
            // MARK: Save ToppingItems to local

            CSWorker.storeLocalToppingItems(toppingItems: toppingItems)
        }
    }

    static func storeToppingGroups() {
        if let toppingGroups = MenuItemsMemStore.toppingGroups {
            // MARK: Save data to local

            CSWorker.storeLocalToppingGroups(toppingGroups: toppingGroups)
        }
    }
    
    // MARK: - CRUD operations - Inner closure
    
    func fetchMenuAndMenuGroups(completionHandler: @escaping (() throws -> MenuAndMenuGroups?) -> Void) {
        do {
            let menu = try CSDatabase.stack.fetchOne(From<CSMenu>())?.toStruct()
            MenuItemsMemStore.menu = menu
            let csMenuItemGroups = try CSDatabase.stack.fetchAll(From<CSMenuItemGroup>()).map { csMenuItemGroup -> MenuGroup in
                let csMenuGroup = csMenuItemGroup.toStruct()
                let menuItems = csMenuItemGroup.menuItems.map { csMenuItem -> MenuItem in
                    csMenuItem.toStruct()
                }
                return MenuGroup(id: csMenuGroup.id, name: csMenuGroup.name, menuId: menu?.id, menuItems: menuItems)
            }
                
            print("🍀 🍀 🍀 🍀 🍀 🍀 🍀 🍀 🍀 🍀 🍀 🍀 🍀")
 
            completionHandler {
                MenuAndMenuGroups(menu: menu, menuGroups: csMenuItemGroups)
            }
        }
        catch {
            completionHandler {
                throw MenuItemsStoreError.CannotFetch("Cannot fetch menu and menuItemGroup from Local")
            }
        }
    }
  
    func searchMenuAndMenuGroups(keyword: String, completionHandler: @escaping (() throws -> MenuAndMenuGroups?) -> Void) {
        do {
            let menu = try CSDatabase.stack.fetchOne(From<CSMenu>())?.toStruct()
            let csMenuItemGroups = try CSDatabase.stack.fetchAll(From<CSMenuItemGroup>()).map { csMenuItemGroup -> MenuGroup in
                let csMenuGroup = csMenuItemGroup.toStruct()
                var menuItems: MenuItems = []
                menuItems = csMenuItemGroup.menuItems.map { csMenuItem -> MenuItem in
                    csMenuItem.toStruct()
                }
                if keyword != nil && keyword != "" {
                    menuItems = menuItems.filter { menuItem -> Bool in
                        menuItem.name.contains(keyword)
                    }
                }
                return MenuGroup(id: csMenuGroup.id, name: csMenuGroup.name, menuId: menu?.id, menuItems: menuItems)
            }
                
            print("🍀 🍀 🍀 🍀 🍀 🍀 🍀 🍀 🍀 🍀 🍀 🍀 🍀")
 
            completionHandler {
                MenuAndMenuGroups(menu: menu, menuGroups: csMenuItemGroups)
            }
        }
        catch {
            completionHandler {
                throw MenuItemsStoreError.CannotFetch("Cannot fetch menu and menuItemGroup from Local")
            }
        }
    }
    
    func fetchMenuItems(completionHandler: @escaping (() throws -> [MenuItem]?) -> Void) {
        do {
            let menuItems = try CSDatabase.stack.fetchAll(From<CSMenuItem>()).map { csMenuItem -> MenuItem in
                csMenuItem.toStruct()
            }
            completionHandler {
                menuItems
            }
        }
        catch {
            completionHandler {
                throw MenuItemsStoreError.CannotFetch("Cannot fetch MenuItems from Local")
            }
        }
    }

    func fetchToppingItems(completionHandler: @escaping (() throws -> [ToppingItem]?) -> Void) {
        do {
            let toppingItems = try CSDatabase.stack.fetchAll(From<CSToppingItem>()).map { csToppingItem -> ToppingItem in
                csToppingItem.toStruct()
            }
            completionHandler {
                toppingItems
            }
        }
        catch {
            completionHandler {
                throw MenuItemsStoreError.CannotFetch("Cannot fetch ToppingItems from Local")
            }
        }
    }

    func fetchMenuItemToppings(menuItemId: String, completionHandler: @escaping (() throws -> [ToppingGroup]?) -> Void) {
        do {
            let menuItemToppings = try CSDatabase.stack.fetchAll(From<CSMenuItemTopping>().where(\.$menuItem ~ \.$id == menuItemId))
            
            let menuItem = try CSDatabase.stack.fetchOne(From<CSMenuItem>().where(\.$id == menuItemId))
            
            let toppingGroups: [ToppingGroup]? = menuItem?.menuItemToppings.map { csMenuItemToppings -> ToppingGroup in
                (csMenuItemToppings.toppingItem?.toppingGroup?.toStruct())!
            }
            print("🍀 🍀 🍀 🍀 🍀 🍀 fetchMenuItemToppings 🍀 🍀 🍀 🍀 🍀 🍀 🍀")
//            print(menuItem?.toStruct())
//            print(menuItem?.menuItemToppings.map { csMenuItemToppings -> ToppingItem in
//                (csMenuItemToppings.toppingItem?.toStruct())!
//            })
//            print(menuItem?.menuItemToppings.map { csMenuItemToppings -> ToppingGroup in
//                (csMenuItemToppings.toppingItem?.toppingGroup?.toStruct())!
//            })
//            print("---------------------------------------------------------------")
//            print(menuItemId)
//            print(toppingGroups)
            print("🍀 🍀 🍀 🍀 🍀 🍀 fetchMenuItemToppings 🍀 🍀 🍀 🍀 🍀 🍀 🍀")
            completionHandler {
                Array(Set(toppingGroups ?? []))
            }
        }
        catch {
            completionHandler {
                throw MenuItemsStoreError.CannotFetch("Cannot fetch menuItem with id \(menuItemId)")
            }
        }
    }
  
    func createMenuItem(menuItemToCreate: MenuItem, completionHandler: @escaping (() throws -> MenuItem?) -> Void) {
        var menuItem = menuItemToCreate
        generateMenuItemID(menuItem: &menuItem)
        calculateMenuItemTotal(menuItem: &menuItem)
        type(of: self).menuItems.append(menuItem)
        completionHandler { menuItem }
    }
  
    func updateMenuItem(menuItemToUpdate: MenuItem, completionHandler: @escaping (() throws -> MenuItem?) -> Void) {
        if let index = indexOfMenuItemWithID(id: menuItemToUpdate.id) {
            type(of: self).menuItems[index] = menuItemToUpdate
            let menuItem = type(of: self).menuItems[index]
            completionHandler { menuItem }
        }
        else {
            completionHandler { throw MenuItemsStoreError.CannotUpdate("Cannot fetch menuItem with id \(String(describing: menuItemToUpdate.id)) to update") }
        }
    }
  
    func deleteMenuItem(id: String, completionHandler: @escaping (() throws -> MenuItem?) -> Void) {
        if let index = indexOfMenuItemWithID(id: id) {
            let menuItem = type(of: self).menuItems.remove(at: index)
            completionHandler { menuItem }
        }
        else {
            completionHandler { throw MenuItemsStoreError.CannotDelete("Cannot fetch menuItem with id \(id) to delete") }
        }
    }

    // MARK: - Convenience methods
  
    private func indexOfMenuItemWithID(id: String?) -> Int? {
        return type(of: self).menuItems.firstIndex { return $0.id == id }
    }
}
