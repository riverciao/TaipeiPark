//
//  AppDelegateExtensions.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/6.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

extension AppDelegate {
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}
