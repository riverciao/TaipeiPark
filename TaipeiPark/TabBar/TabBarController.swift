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
        
        let viewControllers = itemTypes.map(TabBarController.prepare)
        setViewControllers(viewControllers, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: View lifr cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Prepare item type
    
    static func prepare(for itemType: TabBarItemType) -> UIViewController {
        switch itemType {
        case .list:
            let client = APIClient()
            let provider = ParkAPIProvider(client: client)
            let parksTableViewController = ParksTableViewController(provider: provider)
            parksTableViewController.provider.fetch()
            
            let navigationController = UINavigationController(rootViewController: parksTableViewController)
            return navigationController
            
        case .map:
            let mapViewController = LocationViewController()
            let navigationController = UINavigationController(rootViewController: mapViewController)
            return navigationController
            
        case .favorite:
            
            // TODO: load core data to ParksTableViewController
            let client = APIClient()
            let provider = ParkAPIProvider(client: client)
            let parksTableViewController = ParksTableViewController(provider: provider)
            parksTableViewController.provider.fetch()
            
            let navigationController = UINavigationController(rootViewController: parksTableViewController)
            return navigationController
        }
    }
    
}
