//
//  UINibExtensions.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/30.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

extension UINib {
    public class func load(nibName name: String, bundle: Bundle? = nil) -> Any? {
        return UINib(nibName: name, bundle: bundle)
            .instantiate(withOwner: nil, options: nil)
            .first
    }
}

extension UIView {
    public class func load(nibName name: String, bundle: Bundle? = nil) -> UIView? {
        return UINib.load(nibName: name, bundle: bundle) as? UIView
    }
}
