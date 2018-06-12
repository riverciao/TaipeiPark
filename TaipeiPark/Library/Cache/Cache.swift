//
//  Cache.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/12.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation

public protocol Cache {
    typealias Completion = () -> Void
    typealias RetrieveSuccess<T: Cachable> = (_ object: T) -> Void
    func store<T: Cachable>(object: T, for key: URL, completion: Completion?)
    func retrieve<T: Cachable>(for key: URL, completion: @escaping RetrieveSuccess<T>)
    func fileExists(for key: URL) -> Bool
}
