//
//  AppDelegate.swift
//  smartPOS
//
//  Created by Raymond Law on 2/12/19.
//  Copyright © 2019 Clean Swift LLC. All rights reserved.
//

import CoreData
import IQKeyboardManagerSwift
import PusherSwift
import PushNotifications
import SlideMenuControllerSwift
import SwiftEventBus
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PusherDelegate {
    var window: UIWindow?
  
    let pushNotifications = PushNotifications.shared
    // You must retain a strong reference to the Pusher instance
    var pusher: Pusher!
    
    func setupPushNotifications() {
        self.pushNotifications.start(instanceId: "77650b88-b6b2-4178-9fc2-95c36493470d")
        self.pushNotifications.registerForRemoteNotifications()
        try? self.pushNotifications.addDeviceInterest(interest: APIConfig.channelName)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        application.registerForRemoteNotifications()
       
        IQKeyboardManager.shared.enable = true
        
        // Override point for customization after application launch.
        self.subscribeToNoInternetService()
        
        self.setupPushNotifications()
        
        let options = PusherClientOptions(
            host: .cluster("ap1")
        )

        pusher = Pusher(
            key: "29ff5ecb5e2501177186",
            options: options
        )

        pusher.delegate = self

        // subscribe to channel
        let channel = self.pusher.subscribe(APIConfig.channelName)

        // bind a callback to handle an event
        _ = channel.bind(eventName: "order-status", eventCallback: { (event: PusherEvent) -> Void in
            guard let json: String = event.data,
                  let jsonData: Data = json.data(using: .utf8)
            else {
                print("Could not convert JSON string to data")
                return
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .customISO8601
            let decoded = try? decoder.decode(RTDataOrder.self, from: jsonData)
            guard let orderUpdate = decoded else {
                print("Could not decode price update")
                return
            }
            print("🔔 order-status", orderUpdate)
            SwiftEventBus.post("RTOrderStatus", sender: orderUpdate.order)
            
        })

        self.pusher.connect()

        // MARK: Need have api to check available id

        ////        self.createActivateCodeView()
//
        if APIConfig.getToken() == "" {
            self.createLoginView()
        } else {
            self.createMenuView()
        }
//      self.openOrderDetailView(orderId: "62983c29-b5d0-4f28-9d66-fefc664c6aec")

        // Triger event when callApi got code 401
        SwiftEventBus.onMainThread(self, name: "Unauthorized") { _ in
            APIConfig.setToken(token: "")
            self.createLoginView()
        }
 
        return true
    }
    
    // print Pusher debug messages
    func debugLog(message: String) {
        print(message)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.pushNotifications.registerDeviceToken(deviceToken)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        self.pushNotifications.handleNotification(userInfo: userInfo)
        
        Deeplinker.handleRemoteNotification(userInfo)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
  
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
  
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
  
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // handle any deeplink
        Deeplinker.checkDeepLink()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Setup show view controller
    
    fileprivate func createMenuView() {
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        let rightViewController = storyboard.instantiateViewController(withIdentifier: "RightViewController") as! RightViewController
        
        let nvc = UINavigationController(rootViewController: mainViewController)
        
        UINavigationBar.appearance().tintColor = UIColor(hex: "FF6B35")
        
        leftViewController.mainViewController = nvc
        
        let slideMenuController = ExSlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController, rightMenuViewController: rightViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        self.window?.backgroundColor = UIColor(white: 0.98, alpha: 1)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }

    fileprivate func createActivateCodeView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ActivateCodeViewController") as! ActivateCodeViewController
        self.window?.backgroundColor = UIColor(white: 0.98, alpha: 1)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
    
    fileprivate func createLoginView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.window?.backgroundColor = UIColor(white: 0.98, alpha: 1)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
    
    fileprivate func subscribeToNoInternetService() {
        _ = NoInternetService()
        // Handle Sync Data from Server SetInverval = 10000ms
        _ = SyncService()
        // todo - rest of the services
    }

    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "dekatotoro.test11" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "test11", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("test11.sqlite")
        var error: NSError?
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error?.debugDescription ?? ""), \(error?.userInfo.debugDescription ?? "")")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        if let moc = self.managedObjectContext {
            var error: NSError?
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error?.debugDescription ?? ""), \(error?.userInfo.debugDescription ?? "")")
                    abort()
                }
            }
        }
    }
}
