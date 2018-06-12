//
//  UIImage+Cache.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/12.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

extension UIImage: Cachable {
    public typealias CacheType = UIImage
    public func decode(_ data: Data) -> CacheType? {
        return UIImage(data: data)
    }
    public func encode() -> Data? {
        if hasAlpha {
            return UIImagePNGRepresentation(self)
        }
        return UIImageJPEGRepresentation(self, 1.0)
    }
    
}

extension UIImage {
    var hasAlpha: Bool {
        guard let alpha = cgImage?.alphaInfo else { return false }
        switch alpha {
        case .none, .noneSkipFirst, .noneSkipLast:
            return false
        default:
            return true
        }
    }
}
