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
    
    let pinType: PinType
    
    init(pinType: PinType) {
        self.pinType = pinType
        super.init()
    }
}
