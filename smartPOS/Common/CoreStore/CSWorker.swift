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
        CSMenusWorker.stack.perform(
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
                            } catch let error {
                                throw error
                            }
                        }
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

    static func storeLocalMenu(menu: Menu) {
        print("🍀 IAM SAVING Menu TO LOCALSTORE")
        CSMenusWorker.stack.perform(
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
    static func clearStoreLocalMenu(){
        // MARK: Delete Data from Local
            CSMenusWorker.stack.perform(
                asynchronous: { (transaction) in
                    try transaction.deleteAll(From<CSMenuItem>())
                },
                completion: { _ in }
            )
        
    }
}
