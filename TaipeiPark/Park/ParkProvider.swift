//
//  ParkProvider.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/27.
//  Copyright © 2018年 riverciao. All rights reserved.
//

protocol ParkProviderDelegate: class {
    func didFetch(by provider: ParkProvider)
    func didFail(with error: Error, by provider: ParkProvider)
}

import Foundation

protocol ParkProvider {
    
    // MARK: Property
    
    weak var delegate: ParkProviderDelegate? { get set }
    var hasMoreParks: Bool { get }
    var numberOfParks: Int { get }
    
    // MARK: Data
    
    func fetch()
    func park(at indexPath: IndexPath) -> Park
}
