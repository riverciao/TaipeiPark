//
//  ColorTool.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/6.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
    }
}

extension UIColor {
    static let barColor =  UIColor(r: 5, g: 15, b: 20)
    static let mapButtonColor = UIColor(r: 40, g: 177, b: 111)
    static let barTintColor = UIColor.white
    static let likedColor = UIColor(r: 244, g: 193, b: 49)
    static let unlikedColor = UIColor.lightGray
    static let openedColor = UIColor(r: 94, g: 166, b: 255)
    static let closedColor = UIColor(r: 255, g: 12, b: 93)
}
