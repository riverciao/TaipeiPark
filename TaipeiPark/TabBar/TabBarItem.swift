//
//  TabBarItem.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/29.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

class TabBarItem: UITabBarItem {
    
    var tabBarItemType: TabBarItemType?
    
    init(tabBarItemType: TabBarItemType) {
        super.init()
        self.tabBarItemType = tabBarItemType
        self.title = tabBarItemType.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
