//
//  ParkAPIClient.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/26.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation

protocol ParkAPIClient {
    
    // MARK: Read Parks
    
    typealias ReadParksSuccess = (_ parks: [Park], _ next: Page) -> Void
    typealias ReadParksFailure = (_ error: Error) -> Void
    
    func readParks(page: Page, numberOfParksInPage: Int, success: @escaping ReadParksSuccess, failure: ReadParksFailure?)
}

protocol ParkDetailAPIClient {
    
    // MARK: Read Facility
    
    typealias ReadFacilitySuccess = (_ facilities: [Facility]) -> Void
    typealias ReadFacilityFailure = (_ error: Error) -> Void
    
    func readFacilities(by parkName: String, success: @escaping ReadFacilitySuccess, failure: ReadFacilityFailure?)
    
    // MARK: Read Spot
    
    typealias ReadSpotSuccess = (_ spots: [Spot]) -> Void
    typealias ReadSpotFailure = (_ error: Error) -> Void
    
    func readSpots(by parkName: String, success: @escaping ReadSpotSuccess, failure: ReadSpotFailure?)
}
