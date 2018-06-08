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
            
        // MARK: List
            
        case .list:
            // MARK: ParkProvider
            let client = APIClient()
            let provider = ParkAPIProvider(client: client)
            let parksTableViewController = ParksTableViewController(provider: provider)
            parksTableViewController.provider.fetch()
            
            // MARK: LikedParkProvider
            let likedParkProvider = LikedParkLocalProvider()
            likedParkProvider.persistenceDelegate = AppDelegate.shared.persistenceManager
            parksTableViewController.likedParkProvider = likedParkProvider
            parksTableViewController.persistenceDelegate = AppDelegate.shared.persistenceManager
            
            let navigationController = NavigationController(rootViewController: parksTableViewController)
            navigationController.tabBarItem = TabBarItem(itemType: .list)
            return navigationController
            
        // MARK: Map
            
        case .map:
            let client = APIClient()
            let provider = LocationParkAPIProvider(client: client)
            let locationViewController = LocationViewController(provider: provider)
            let navigationController = NavigationController(rootViewController: locationViewController)
            navigationController.tabBarItem = TabBarItem(itemType: .map)

            return navigationController
            
        // MARK: Favorite
            
        case .favorite:
            
            // MARK: ParkProvider
            let provider = LikedParkLocalProvider()
            provider.persistenceDelegate = AppDelegate.shared.persistenceManager
            let parksTableViewController = ParksTableViewController(provider: provider)
            parksTableViewController.provider.fetch()
            
            // MARK: LikedParkProvider
            parksTableViewController.likedParkProvider = provider
            parksTableViewController.persistenceDelegate = AppDelegate.shared.persistenceManager
            
            let navigationController = NavigationController(rootViewController: parksTableViewController)
            navigationController.tabBarItem = TabBarItem(itemType: .favorite)
            
            return navigationController
        }
    }
}

extension UITabBarController {
    func visibleViewController(of itemType: TabBarItemType) -> UIViewController? {
        var tabIndex: Int? = nil
        switch itemType {
        case .list: tabIndex = 0
        case .map: tabIndex = 1
        case .favorite: tabIndex = 2
        }
        if let navigationController = self.viewControllers?[tabIndex!] as? NavigationController {
            if let visibleController = navigationController.visibleViewController {
                return visibleController
            }
        }
        return nil
    }
}
