//
//  LikedProductLocalProvider.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/6.
//  Copyright © 2018年 riverciao. All rights reserved.
//

// MARK: LikedParkLocalProviderDelegate

protocol LikedParkLocalProviderDelegate: class {
    func didFail(with error: Error, by controller: LikedParkProvider)
}

// MARK: LikedParkLocalProvider

import CoreData

class LikedParkLocalProvider: LikedParkProvider {
    
    // MARK: Property
    
    public weak final var persistenceDelegate: PersistenceDelegate?
    public weak final var delegate: LikedParkLocalProviderDelegate?

}

extension LikedParkLocalProvider: LikedParkProvider {
 
    private func validatePersistence() throws -> PersistenceDelegate {
        guard let persistenceDelegate = persistenceDelegate else {
            throw PersistenceError.persistenceNotFound
        }
        return persistenceDelegate
    }
    
    /// Should save context manually after execute this method.
    public func likePark(id: ParkId) throws {
        
    }
    
    /// Should save context manually after execute this method.
    public func removeLikedPark(id: ParkId) throws {
        let persistenceDelegate = try validatePersistence()
        let request: NSFetchRequest<LikedParkEntity> = LikedParkEntity.fetchRequest()
        request.predicate = NSPredicate(format: "parkId == %@", id.rawValue)
        
        try persistenceDelegate.performTask(in: .main) { (context) in
            let likedParkObjects = try context.fetch(request)
            likedParkObjects.forEach({ (likedParkObject) in
                context.delete(likedParkObject)
            })
        }
    }
    
    /// Should save context manually after execute this method.
    public func isLikedPark(id: ParkId) -> Bool {
        
    }
}
