//
//  LikedProductLocalProvider.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/6.
//  Copyright © 2018年 riverciao. All rights reserved.
//

// MARK: LikedParkLocalProviderDelegate

protocol LikedParkLocalProviderDelegate {
    func didFail(with error: Error, by controller: LikedParkProvider)
}

// MARK: LikedParkLocalProvider

import CoreData

class LikedParkLocalProvider: LikedParkProvider {
    func isLikedPark(id: ParkId) -> Bool {
        
    }
    
    func likePark(id: ParkId) throws {
        
    }
    
    func removeLikedPark(id: ParkId) throws {
        
    }
    
    
}
