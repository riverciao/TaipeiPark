//
//  PersistenceDelegate.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/6.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import CoreData

public protocol PersistenceDelegate: class {
    
    @discardableResult
    func performTask<Result>(
        in queqe: PersistenceQueue,
        execution task: @escaping (_ context: NSManagedObjectContext) throws -> Result
        )
        throws -> Result
}
