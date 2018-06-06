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
    
    public init(_ park: Park) throws {
        self.parkId = park.id
        let parkData = try JSONEncoder().encode(park)
        self.parkData = parkData
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
        guard let parkData = likedParkObject.parkData else {
            throw ModelError.missingValueForKey(Schema.parkData)
        }
        self.parkId = ParkId(rawValue: parkIdValue)
        self.parkData = parkData
    }
    
    public func makeManagedObject(in context: NSManagedObjectContext) throws -> NSManagedObject {
        let likedPark = LikedParkEntity(context: context)
        likedPark.parkId = parkId.rawValue
        likedPark.parkData = parkData
        return likedPark
    }
}
