//
//  UIViewExtensions.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/5.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

public extension UIView {
    public func allConstraints(equalTo superView: UIView) {
        self.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
        self.leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
    }
}
