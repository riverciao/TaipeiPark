//
//  MemoryCache.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/12.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

class MemoryCache: Cache {
    
    public let cache = NSCache<AnyObject, AnyObject>()
    public func fileExists(for key: URL) -> Bool {
        let key = key as AnyObject
        if cache.object(forKey: key) != nil { return true }
        return false
    }
    
    func store<T: Cachable>(object: T, for key: URL, completion: Cache.Completion?) {
        DispatchQueue.global().async {
            let key = key as AnyObject
            let object = object as AnyObject
            self.cache.setObject(object, forKey: key)
            completion?()
        }
    }
    
    func retrieve<T: Cachable>(for key: URL, completion: @escaping (T) -> Void) {
        DispatchQueue.global().async {
            let key = key as AnyObject
            if let object = self.cache.object(forKey: key) as? T {
                completion(object)
            }
        }
    }
}
