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

protocol ParkDetailProviderDelagate: class {
    
    // MARK: Facility
    
    func didFetchFacility(by provider: ParkDetailProvider)
    func didFailToFacility(with error: Error, by provider: ParkDetailProvider)
    
    // MARK: Spot
    
    func didFetchSpot(by provider: ParkDetailProvider)
    func didFailToSpot(with error: Error, by provider: ParkDetailProvider)
}

import Foundation

protocol ParkProvider: class {
    
    // MARK: Property

    weak var delegate: ParkProviderDelegate? { get set }
    var hasMoreParks: Bool { get }
    var numberOfParks: Int { get }
    
    // MARK: Data

    var parks: [Park] { get }
    func fetch()
    func park(at indexPath: IndexPath) -> Park
}

protocol ParkDetailProvider: class {
    
    // MARK: Property
    
    weak var parkDetailDelegate: ParkDetailProviderDelagate? { get set }
    var facilitiesDescription: String { get }
    var numberOfSpots: Int { get }
    var isSpotsFetched: Bool { get }
    
    // MARK: Data
    
    func fetchFacility(by parkName: String)
    func fetchSpot(by parkName: String)
    func spot(at index: IndexPath) -> Spot
}
