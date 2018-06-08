//
//  CustomPointAnnotation.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/8.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import MapKit

enum PinType {
    case open
    case close
}

class CustomPointAnnotation: MKPointAnnotation {
    
    class var identifier: String { return String(describing: self) }
    let pinType: PinType
    
    init(pinType: PinType) {
        self.pinType = pinType
        super.init()
    }
}
