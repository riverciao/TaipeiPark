//
//  TabBarItemType.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/29.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation
import UIKit

enum TabBarItemType {
    case list, map, favorite
}

// MARK: Title

extension TabBarItemType {
    var title: String {
        switch self {
        case .list:
            return NSLocalizedString("列表", comment: "")
        case .map:
            return NSLocalizedString("地圖", comment: "")
        case .favorite:
            return NSLocalizedString("最愛", comment: "")
        }
    }
}

// MARK: Image

extension TabBarItemType {
    var image: UIImage {
        switch self {
        case .list:
            return #imageLiteral(resourceName: "icon-list").withRenderingMode(.alwaysTemplate)
        case .map:
            return #imageLiteral(resourceName: "icon-location").withRenderingMode(.alwaysTemplate)
        case.favorite:
            return #imageLiteral(resourceName: "icon-star").withRenderingMode(.alwaysTemplate)
        }
    }
}

