//
//  LikedPark.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/6.
//  Copyright © 2018年 riverciao. All rights reserved.
//

enum ModelError: Error {
    case invalidEntityType(NSManagedObject.Type, forUsingType: NSManagedObject.Type)
    case missingValueForKey(String)
}

public struct LikedPark {
    
    // MARK: Schema
    
    public struct Schema {
        public static let parkId = "parkId"
        public static let parkData = "parkData"
    }
    
    // MARK: Property
    
    public let parkId: ParkId
    public let parkData: Data
    
    // MARK: Init
    
    public init(park: Park) {
        self.parkId = park.id
        let parkData = try JSONEncoder.encode(park)
    }
}

import CoreData

extension LikedPark {
    public init(_ managedObject: NSManagedObject) throws {
        guard let likedParkObject = managedObject as? LikedParkEntity else {
            throw ModelError.invalidEntityType(type(of: managedObject).self, forUsingType: LikedParkEntity.self)
        }
        guard let parkIdValue = likedParkObject.parkId else {
            throw ModelError.missingValueForKey(Schema.parkId)
        }
        self.parkId = ParkId(rawValue: parkIdValue)
    }
    
    public func makeManagedObject(in context: NSManagedObjectContext) throws -> NSManagedObject {
        let likedPark = LikedParkEntity(context: context)
        likedPark.parkId = parkId.rawValue
//        likedPark.parkData = //ParkData
        return likedPark
    }
}
