//
//  LikedParkProvider.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/6.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation

public protocol LikedParkProvider {
    func isLikedPark(id: String) -> Bool
    func likePark(id: String) throws
    func removeLikedPark(id: String) throws
}
