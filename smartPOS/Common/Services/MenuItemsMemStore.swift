//
//  MenuItemsMemStore.swift
//  smartPOS
//
//  Created by I Am Focused on 22/04/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import Foundation

class MenuItemsMemStore: MenuItemsStoreProtocol, MenuItemsStoreUtilityProtocol
{
    // MARK: - Data
    static var merchant = Merchant(id: "MERCHANT-123", name: "Merchant Smart")
    static var restaurant = Restaurant(id: "RES-123", merchant: merchant, name: "Restaurant Smart", imageUrl: "", videoUrl: "", numRate: 4, rating: 4.5, area: "HCM", isActive: true)
    static var menu = Menu(id: "MENU-123", restaurent: restaurant, name: "Menu Smart", index: 1)
    
    static var menuItems: [MenuItem] = [
        MenuItem(id: "ABC-123", menu: menu, name: "Pizza", description: "Nothing to show more", price: 2000, imageUrl: "pizza", numLikes: 100, index: 1, isActive: true),
        MenuItem(id: "ABC-234", menu: menu, name: "Hamburger", description: "Nothing to show more", price: 10000, imageUrl: "hamburger", numLikes: 100, index: 1, isActive: true),
        MenuItem(id: "ABC-345", menu: menu, name: "Hamburger", description: "Nothing to show more", price: 200000, imageUrl: "pizza", numLikes: 100, index: 1, isActive: true),
        MenuItem(id: "ABC-456", menu: menu, name: "Pizza", description: "Nothing to show more", price: 49000, imageUrl: "pizza", numLikes: 100, index: 1, isActive: true),
        MenuItem(id: "ABC-567", menu: menu, name: "Pizza", description: "Nothing to show more", price: 45000, imageUrl: "pizza", numLikes: 100, index: 1, isActive: true),
        MenuItem(id: "ABC-678", menu: menu, name: "Pizza", description: "Nothing to show more", price: 30000, imageUrl: "pizza", numLikes: 100, index: 1, isActive: true),
    ]
  
    // MARK: - CRUD operations - Optional error
  
    func fetchMenuItems(completionHandler: @escaping ([MenuItem], MenuItemsStoreError?) -> Void) {
        completionHandler(type(of: self).menuItems, nil)
    }
  
    func fetchMenuItem(id: String, completionHandler: @escaping (MenuItem?, MenuItemsStoreError?) -> Void) {
        if let index = indexOfMenuItemWithID(id: id)
        {
            let menuItem = type(of: self).menuItems[index]
            completionHandler(menuItem, nil)
        }
        else
        {
            completionHandler(nil, MenuItemsStoreError.CannotFetch("Cannot fetch menuItem with id \(id)"))
        }
    }
  
    func createMenuItem(menuItemToCreate: MenuItem, completionHandler: @escaping (MenuItem?, MenuItemsStoreError?) -> Void) {
        var menuItem = menuItemToCreate
        generateMenuItemID(menuItem: &menuItem)
        calculateMenuItemTotal(menuItem: &menuItem)
        type(of: self).menuItems.append(menuItem)
        completionHandler(menuItem, nil)
    }
  
    func updateMenuItem(menuItemToUpdate: MenuItem, completionHandler: @escaping (MenuItem?, MenuItemsStoreError?) -> Void) {
        if let index = indexOfMenuItemWithID(id: menuItemToUpdate.id) {
            type(of: self).menuItems[index] = menuItemToUpdate
            let menuItem = type(of: self).menuItems[index]
            completionHandler(menuItem, nil)
        }
        else {
            completionHandler(nil, MenuItemsStoreError.CannotUpdate("Cannot fetch menuItem with id \(String(describing: menuItemToUpdate.id)) to update"))
        }
    }
  
    func deleteMenuItem(id: String, completionHandler: @escaping (MenuItem?, MenuItemsStoreError?) -> Void) {
        if let index = indexOfMenuItemWithID(id: id) {
            let menuItem = type(of: self).menuItems.remove(at: index)
            completionHandler(menuItem, nil)
            return
        }
        completionHandler(nil, MenuItemsStoreError.CannotDelete("Cannot fetch menuItem with id \(id) to delete"))
    }
  
    // MARK: - CRUD operations - Generic enum result type
  
    func fetchMenuItems(completionHandler: @escaping MenuItemsStoreFetchMenuItemsCompletionHandler) {
        completionHandler(MenuItemsStoreResult.Success(result: type(of: self).menuItems))
    }
  
    func fetchMenuItem(id: String, completionHandler: @escaping MenuItemsStoreFetchMenuItemCompletionHandler) {
        let menuItem = type(of: self).menuItems.filter { (menuItem: MenuItem) -> Bool in
            menuItem.id == id
        }.first
        if let menuItem = menuItem {
            completionHandler(MenuItemsStoreResult.Success(result: menuItem))
        }
        else {
            completionHandler(MenuItemsStoreResult.Failure(error: MenuItemsStoreError.CannotFetch("Cannot fetch menuItem with id \(id)")))
        }
    }
  
    func createMenuItem(menuItemToCreate: MenuItem, completionHandler: @escaping MenuItemsStoreCreateMenuItemCompletionHandler) {
        var menuItem = menuItemToCreate
        generateMenuItemID(menuItem: &menuItem)
        calculateMenuItemTotal(menuItem: &menuItem)
        type(of: self).menuItems.append(menuItem)
        completionHandler(MenuItemsStoreResult.Success(result: menuItem))
    }
  
    func updateMenuItem(menuItemToUpdate: MenuItem, completionHandler: @escaping MenuItemsStoreUpdateMenuItemCompletionHandler) {
        if let index = indexOfMenuItemWithID(id: menuItemToUpdate.id) {
            type(of: self).menuItems[index] = menuItemToUpdate
            let menuItem = type(of: self).menuItems[index]
            completionHandler(MenuItemsStoreResult.Success(result: menuItem))
        }
        else {
            completionHandler(MenuItemsStoreResult.Failure(error: MenuItemsStoreError.CannotUpdate("Cannot update menuItem with id \(String(describing: menuItemToUpdate.id)) to update")))
        }
    }
  
    func deleteMenuItem(id: String, completionHandler: @escaping MenuItemsStoreDeleteMenuItemCompletionHandler) {
        if let index = indexOfMenuItemWithID(id: id) {
            let menuItem = type(of: self).menuItems.remove(at: index)
            completionHandler(MenuItemsStoreResult.Success(result: menuItem))
            return
        }
        completionHandler(MenuItemsStoreResult.Failure(error: MenuItemsStoreError.CannotDelete("Cannot delete menuItem with id \(id) to delete")))
    }
  
    // MARK: - CRUD operations - Inner closure
  
    func fetchMenuItems(completionHandler: @escaping (() throws -> [MenuItem]) -> Void) {
        completionHandler { type(of: self).menuItems }
    }
  
    func fetchMenuItem(id: String, completionHandler: @escaping (() throws -> MenuItem?) -> Void) {
        if let index = indexOfMenuItemWithID(id: id) {
            completionHandler { type(of: self).menuItems[index] }
        }
        else {
            completionHandler { throw MenuItemsStoreError.CannotFetch("Cannot fetch menuItem with id \(id)") }
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
