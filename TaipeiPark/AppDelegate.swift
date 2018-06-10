//
//  AppDelegate.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/25.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var persistenceManager: PersistenceManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let persistenceManager = PersistenceManager(container: NSPersistentContainer(name: "TaipeiPark"))
        persistenceManager.container.loadPersistentStores { (_, error) in
            guard let error = error else { return }
            print("error: \(error)")
        }
        self.persistenceManager = persistenceManager
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let tabBarController = TabBarController(
            itemTypes: [.list, .map, .favorite]
        )
        window?.rootViewController = tabBarController
        
        return true
    }
}

