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
    
    init(itemType: TabBarItemType) {
        super.init()
        self.tabBarItemType = itemType
        self.title = itemType.title
        self.image = itemType.image
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
