//
//  DiskCache.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/12.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation

class DiskCache: Cache {
    
    private let fileManager = FileManager()
    private let diskCacheQueue = DispatchQueue(label: "DiskCacheQueue")
    public let path: URL = {
        let basePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        let url = URL(string: basePath)!.appendingPathComponent("DiskCache")
        return url
    }()
    
    func fileExists(for key: URL) -> Bool {
        let filePath = path.appendingPathComponent(key.absoluteString)
        if fileManager.fileExists(atPath: filePath.absoluteString) {
           return true
        }
        return false
    }
    
    func store<T: Cachable>(object: T, for key: URL, completion: Cache.Completion?) {
        
        DispatchQueue.global().async {
            if !self.fileManager.fileExists(atPath: self.path.absoluteString) {
                do {
                    try self.fileManager.createDirectory(at: self.path, withIntermediateDirectories: true, attributes: nil)
                } catch { }
            }
            let filePath = self.path.appendingPathComponent(key.absoluteString)
            self.fileManager.createFile(atPath: filePath.absoluteString, contents: object.encode(), attributes: nil)
        }
        completion?()
    }
    
    func retrieve<T: Cachable>(for key: URL, completion: @escaping (T) -> Void) {
        let filePath = path.appendingPathComponent(key.absoluteString)
        DispatchQueue.global().async {
            let object = try? Data(contentsOf: filePath)
            if let object = object as? T {
                completion(object)
            }
        }
    }
}
