//
//  PersistenceManager.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/6.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import CoreData

public final class PersistenceManager {
    
    // MARK: Property
    let container: NSPersistentContainer
    
    // MARK: Init
    init(container: NSPersistentContainer) {
        self.container = container
    }
}

extension PersistenceManager: PersistenceDelegate {
    public func performTask<Result>(in queue: PersistenceQueue, execution task: @escaping (NSManagedObjectContext) throws -> Result) throws -> Result {
        switch queue {
        case .main:
            let context = container.viewContext
            return try task(context)
        case .background:
            let context = container.newBackgroundContext()
            return try task(context)
        }
    }
}
