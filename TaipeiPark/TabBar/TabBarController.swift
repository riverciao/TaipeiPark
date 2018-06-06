//
//  TabBarController.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/29.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: Init
    
    init(itemTypes: [TabBarItemType]) {
        super.init(nibName: nil, bundle: nil)
        
        let viewControllers: [UIViewController] = itemTypes.map(TabBarController.prepare)
        setViewControllers(viewControllers, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: View lifr cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
    }
    
    // MARK: SetUp
    
    private func setUpTabBar() {
        tabBar.barStyle = .default
        tabBar.isTranslucent = false
        tabBar.tintColor = .barColor
    }
    
    // MARK: Prepare item type
    
    static func prepare(for itemType: TabBarItemType) -> UIViewController {
        switch itemType {
        case .list:
            let client = APIClient()
            let provider = ParkAPIProvider(client: client)
            let parksTableViewController = ParksTableViewController(provider: provider)
            parksTableViewController.provider.fetch()
            
            // MARK: Like Park
            let likedParkProvider = LikedParkLocalProvider()
            likedParkProvider.persistenceDelegate = AppDelegate.shared.persistenceManager
            parksTableViewController.likedParkProvider = likedParkProvider
            parksTableViewController.persistenceDelegate = AppDelegate.shared.persistenceManager
            
            let navigationController = NavigationController(rootViewController: parksTableViewController)
            navigationController.tabBarItem = TabBarItem(itemType: .list)
            return navigationController
            
        case .map:
            let client = APIClient()
            let provider = ParkAPIProvider(client: client)
            let locationViewController = LocationViewController(provider: provider)
            let navigationController = NavigationController(rootViewController: locationViewController)
            navigationController.tabBarItem = TabBarItem(itemType: .map)

            return navigationController
            
        case .favorite:
            
            // TODO: load core data to ParksTableViewController
            let client = APIClient()
            let provider = ParkAPIProvider(client: client)
            let parksTableViewController = ParksTableViewController(provider: provider)
            parksTableViewController.provider.fetch()
            
            let navigationController = NavigationController(rootViewController: parksTableViewController)
            navigationController.tabBarItem = TabBarItem(itemType: .favorite)
            
            return navigationController
        }
    }
    
}
