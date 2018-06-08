//
//  CustomPointAnnotation.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/8.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import MapKit
import UIKit

enum PinType {
    case open
    case close
}

extension PinType {
    var image: UIImage {
        switch self {
        case .open: return #imageLiteral(resourceName: "icon-openLocation")
        case .close: return #imageLiteral(resourceName: "icon-closeLocation")
        }
    }
}

class CustomPointAnnotation: MKPointAnnotation {
    
    class var identifier: String { return String(describing: self) }
    let pinType: PinType
    
    init(pinType: PinType) {
        self.pinType = pinType
        super.init()
    }
}
