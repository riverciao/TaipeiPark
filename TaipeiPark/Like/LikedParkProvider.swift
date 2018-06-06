//
//  LikedParkProvider.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/6.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation

public protocol LikedParkProvider: class {
    func isLikedPark(id: ParkId) -> Bool
    func likePark(_ park: ParkId) throws
    func removeLikedPark(id: ParkId) throws
}
