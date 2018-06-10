//
//  ParkDetailAPIProvider.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/29.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation

class ParkDetailAPIProvider: ParkDetailProvider {
    
    // MARK: Property
    
    let client: APIClient
    var parkDetailDelegate: ParkDetailProviderDelagate?
    var isSpotsFetched: Bool = false
    private var facilities = [Facility]()
    private var spots = [Spot]()
    
    // MARK: Init
    
    init(client: APIClient) {
        self.client = client
    }
    
    // MARK: ParkDtailProvider
    
    func fetchFacility(by parkName: String) {
        
        client.readFacilities(by: parkName, success: { (facilities) in
            self.facilities = facilities
            self.parkDetailDelegate?.didFetchFacility(by: self)
        }) { (error) in
            self.parkDetailDelegate?.didFailToFacility(with: error, by: self)
        }
    }
    
    func fetchSpot(by parkName: String) {
        
        client.readSpots(by: parkName, success: { (spots) in
            self.spots = spots
            self.isSpotsFetched = true
            self.parkDetailDelegate?.didFetchSpot(by: self)
        }) { (error) in
            self.parkDetailDelegate?.didFailToSpot(with: error, by: self)
        }
    }
    
    // MARK: Provide facility
    
    var facilitiesDescription: String {
        var description = String()
        guard facilities.count-1 > 0 else { return "" }
        for i in 0..<facilities.count-1 {
            description += "\(facilities[i].name)" + "、"
        }
        guard let lastFacility = facilities.last else { return description }
        description += lastFacility.name
        return description
    }
    
    // MARK: Provide spot
    
    func spot(at index: IndexPath) -> Spot {
        return spots[index.row]
    }
    var numberOfSpots: Int {
        return spots.count
    }
}
