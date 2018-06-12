//
//  Cachable.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/12.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation

public protocol Cachable {
    associatedtype CacheType
    func decode(_ data: Data) -> CacheType?
    func encode() -> Data?
}
