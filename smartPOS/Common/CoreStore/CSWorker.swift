//
//  CSWorker.swift
//  smartPOS
//
//  Created by I Am Focused on 15/05/2021.
//  Copyright © 2021 Clean Swift LLC. All rights reserved.
//

import CoreStore
import Foundation

final class CSWorker {
    static func storeLocal(menu: Menu, menuGroups: MenuGroups) {
        CSWorker.storeLocalMenu(menu: menu)
        print("🍀 IAM SAVING MenuGroup TO LOCALSTORE")
        CSDatabase.stack.perform(
            asynchronous: { transaction in
               
                for menuGroup in menuGroups {
                    do {
                        let existingMenuItemGroup = try transaction.fetchOne(From<CSMenuItemGroup>().where(\.$id == menuGroup.id))
                        let csMenuItemGroup = existingMenuItemGroup != nil ? existingMenuItemGroup : transaction.create(Into<CSMenuItemGroup>())
                        csMenuItemGroup?.id = menuGroup.id
//                        csMenuItemGroup?.index = menuGroup.index ?? 0
                        csMenuItemGroup?.name = menuGroup.name
                        csMenuItemGroup?.menu = try transaction.fetchOne(From<CSMenu>().where(\.$id == menuGroup.menuId ?? menu.id))

                        let menuItems = menuGroup.menuItems
                        var csMenuItems:  Array<CSMenuItem> = []
                        for menuItem in menuItems {
                            do {
                                let existingMenuItem = try transaction.fetchOne(From<CSMenuItem>().where(\.$id == menuItem.id))
                                let csMenuItem = existingMenuItem != nil ? existingMenuItem : transaction.create(Into<CSMenuItem>())
                                csMenuItem?.id = menuItem.id
                                csMenuItem?.name = menuItem.name
                                csMenuItem?.description = menuItem.description
//                                csMenuItem?.index = menuItem.index ?? 0
                                csMenuItem?.imageUrl = menuItem.imageUrl
                                csMenuItem?.price = menuItem.price
                                csMenuItem?.isActive = menuItem.isActive ?? true
                                csMenuItem?.menuItemGroup = try transaction.fetchOne(From<CSMenuItemGroup>().where(\.$id == menuGroup.id))
                                csMenuItems.append(csMenuItem!)
                                
                            } catch {
                                throw error
                            }
                        }
                        csMenuItemGroup?.menuItems = csMenuItems
                    } catch {
                        throw error
                    }
                }
            },
            completion: { (result) -> Void in
                switch result {
                case .success(let storage):
                    print("Successfully added sqlite store: \(storage)")
                case .failure(let error):
                    print("Failed adding sqlite store with error: \(error)")
                }
            }
        )
        print("----------------------------------------------------")
    }
    // MARK: Menu
    
    static func storeLocalMenu(menu: Menu) {
        print("🍀 IAM SAVING Menu TO LOCALSTORE")
        print(menu)
        CSDatabase.stack.perform(
            asynchronous: { transaction in
                let existingMenu = try transaction.fetchOne(From<CSMenu>().where(\.$id == menu.id))
                let csMenu = existingMenu != nil ? existingMenu : transaction.create(Into<CSMenu>())
                csMenu?.id = menu.id
//                csMenu?.index = menu.index
                csMenu?.name = menu.name

            },
            completion: { (result) -> Void in
                switch result {
                case .success(let storage):
                    print("Menu: Successfully added sqlite store: \(storage)")
                case .failure(let error):
                    print("Menu: Failed adding sqlite store with error: \(error)")
                }
            }
        )
        print("----------------------------------------------------")
    }
    // MARK: ToppingItems
    static func storeLocalToppingItems(toppingItems: [ToppingItemData]) {
        print("🍀 IAM SAVING ToppingItems TO LOCALSTORE")
        CSDatabase.stack.perform(
            asynchronous: { transaction in
                for toppingItem in toppingItems {
                    let existingToppingItem = try transaction.fetchOne(From<CSToppingItem>().where(\.$id == toppingItem.id))
                    let csToppingItem = existingToppingItem != nil ? existingToppingItem : transaction.create(Into<CSToppingItem>())
                    csToppingItem?.id = toppingItem.id
                    csToppingItem?.name = toppingItem.name
                    csToppingItem?.description = toppingItem.description
                    csToppingItem?.name = toppingItem.name
                    csToppingItem?.isActive = true
                    csToppingItem?.price = toppingItem.price
                    csToppingItem?.maxQuantity = toppingItem.maxQuantity
                        
                    let existingToppingGroup = try transaction.fetchOne(From<CSToppingGroup>().where(\.$id == toppingItem.toppingGroupId))
                    let csToppingGroup = existingToppingGroup != nil ? existingToppingGroup : transaction.create(Into<CSToppingGroup>())
                    csToppingGroup?.id = toppingItem.toppingGroupId
                    csToppingItem?.toppingGroup = csToppingGroup
                    
                    csToppingGroup?.toppingItems = try transaction.fetchAll(From<CSToppingItem>().where(\.$toppingGroup ~ \.$id == toppingItem.toppingGroupId))
                    
                }
                
            },
            completion: { (result) -> Void in
                switch result {
                case .success(let storage):
                    print("ToppingItems: Successfully added sqlite store: \(storage)")
                case .failure(let error):
                    print("ToppingItems: Failed adding sqlite store with error: \(error)")
                }
            }
        )
        print("----------------------------------------------------")
    }
    // MARK: ToppingGroups
    static func storeLocalToppingGroups(toppingGroups: [ToppingGroupData]) {
        print("🍀 IAM SAVING ToppingGroups TO LOCALSTORE")
        CSDatabase.stack.perform(
            asynchronous: { transaction in
                for toppingGroup in toppingGroups {
                    let existingToppingGroup = try transaction.fetchOne(From<CSToppingGroup>().where(\.$id == toppingGroup.id))
                    let csToppingGroup = existingToppingGroup != nil ? existingToppingGroup : transaction.create(Into<CSToppingGroup>())
                    csToppingGroup?.id = toppingGroup.id
                    csToppingGroup?.name = toppingGroup.name
                    csToppingGroup?.isActive = toppingGroup.isActive
                    let csToppingItems: Array<CSToppingItem> = try transaction.fetchAll(From<CSToppingItem>().where(\.$toppingGroup ~ \.$id == toppingGroup.id))
                    csToppingGroup?.toppingItems = csToppingItems
                }
                
            },
            completion: { (result) -> Void in
                switch result {
                case .success(let storage):
                    print("ToppingGroups: Successfully added sqlite store: \(storage)")
                case .failure(let error):
                    print("ToppingGroups: Failed adding sqlite store with error: \(error)")
                }
            }
        )
        print("----------------------------------------------------")
    }
    // MARK: MenuItemToppings
    static func storeLocalMenuItemToppings(menuItemToppings: [MenuItemToppingData]) {
        print("🍀 IAM SAVING MenuItemToppings TO LOCALSTORE")
        CSDatabase.stack.perform(
            asynchronous: { transaction in
                for menuItemTopping in menuItemToppings {
                    let existingMenuItemTopping = try transaction.fetchOne(From<CSMenuItemTopping>().where(\.$id == menuItemTopping.id))
                    let csMenuItemTopping: CSMenuItemTopping? = existingMenuItemTopping != nil ? existingMenuItemTopping : transaction.create(Into<CSMenuItemTopping>())
                    csMenuItemTopping?.id = menuItemTopping.id
                    csMenuItemTopping?.customPrice = menuItemTopping.customPrice
                    
                    let csMenuItem =  try transaction.fetchOne(From<CSMenuItem>().where(\.$id == menuItemTopping.menuItemId))
                    csMenuItemTopping?.menuItem = csMenuItem
                    
                    
                    let csToppingItem = try transaction.fetchOne(From<CSToppingItem>().where(\.$id == menuItemTopping.toppingItemId))
                    csMenuItemTopping?.toppingItem = csToppingItem
                    
                    csToppingItem?.menuItemToppings = try transaction.fetchAll(From<CSMenuItemTopping>().where(\.$toppingItem ~ \.$id == menuItemTopping.toppingItemId))
                    
                    csMenuItem?.menuItemToppings = try transaction.fetchAll(From<CSMenuItemTopping>().where(\.$menuItem ~ \.$id == menuItemTopping.menuItemId))
                    
//                    csMenuItem?.toppingGroups = (csMenuItem?.menuItemToppings.map({ (csMenuItemTopping) -> CSToppingGroup in
//                        (csMenuItemTopping.toppingItem?.toppingGroup)!
//                    }))!
                    
                    
//                    let existingMenuItemToppings : CSMenuItemTopping = try transaction.fetchOne(From<CSMenuItemTopping>().where(\.$id == toppingItem.))
//                    let csMenuItemToppings = existingMenuItemToppings != nil ? existingMenuItemToppings : transaction.create(Into<CSToppingGroup>())
//                    csToppingGroup?.id = toppingItem.toppingGroupId
//                    csToppingItem?.menuItemToppings =
                    
                }
            },
            completion: { (result) -> Void in
                switch result {
                case .success(let storage):
                    print("MenuItemToppings: Successfully added sqlite store: \(storage)")
                case .failure(let error):
                    print("MenuItemToppings: Failed adding sqlite store with error: \(error)")
                }
            }
        )
        print("----------------------------------------------------")
    }
    

    static func clearStoreLocalMenu() {
        // MARK: Delete Data from Local

        CSDatabase.stack.perform(
            asynchronous: { transaction in
                try transaction.deleteAll(From<CSMenu>())
                try transaction.deleteAll(From<CSMenuItemGroup>())
                try transaction.deleteAll(From<CSMenuItem>())
                try transaction.deleteAll(From<CSMenuItemTopping>())
                try transaction.deleteAll(From<CSToppingItem>())
                try transaction.deleteAll(From<CSToppingGroup>())
//                try transaction.deleteAll(From<CSOrder>())
//                try transaction.deleteAll(From<CSOrderItem>())
//                try transaction.deleteAll(From<CSOrderItemTopping>())
            },
            completion: { _ in }
        )
    }
}
