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

class LikedParkLocalProvider: ParkProvider {
    
    // MARK: Property
    
    public weak final var persistenceDelegate: PersistenceDelegate?
    public weak final var likedParkdelegate: LikedParkLocalProviderDelegate?
    public weak final var delegate: ParkProviderDelegate?
    var parks: [Park]
    
    func fetch() {
        do {
            let persistenceDelegate = try validatePersistence()
            var request: NSFetchRequest<LikedParkEntity> = LikedParkEntity.fetchRequest()
            try persistenceDelegate.performTask(in: .background, execution: { context -> Result in
                let likedParkObjects = try context.fetch(request)
                
            })
        } catch {
            
        }
    }
    
    func park(at indexPath: IndexPath) -> Park {
        <#code#>
    }
    var hasMoreParks: Bool {
        
    }
    var numberOfParks: Int {
        
    }
}

extension LikedParkLocalProvider: LikedParkProvider {
 
    private func validatePersistence() throws -> PersistenceDelegate {
        guard let persistenceDelegate = persistenceDelegate else {
            throw PersistenceError.persistenceNotFound
        }
        return persistenceDelegate
    }
    
    /// Should save context manually after execute this method.
    public func likePark(_ park: Park) throws {
        let persistenceDelegate = try validatePersistence()
        try persistenceDelegate.performTask(in: .main) { (context) in
            let likedPark = try LikedPark(park)
            let _ = try likedPark.makeManagedObject(in: context)
        }
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
        do {
            let persistenceDelegate = try validatePersistence()
            let request: NSFetchRequest<LikedParkEntity> = LikedParkEntity.fetchRequest()
            request.predicate = NSPredicate(format: "parkId == %@", id.rawValue)
            
            let isLiked: Bool = try persistenceDelegate.performTask(in: .main, execution: { (context) in
                let likedParkObjects = try context.fetch(request)
                return !likedParkObjects.isEmpty
            })
            return isLiked
            
        } catch {
            delegate?.didFail(with: error, by: self)
            return false
        }
    }
}
