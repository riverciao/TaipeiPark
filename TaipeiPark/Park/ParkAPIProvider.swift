//
//  ParkAPIProvider.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/27.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation

class ParkAPIProvider: ParkProvider {
    
    // MARK: Property
    
    let client: APIClient
    var delegate: ParkProviderDelegate?
    private var page: Page = .begin
    private var parks = [Park]()
    private var pageIsRead = [Page: Bool]()
    
    // MARK: Init
    
    init(client: APIClient) {
        self.client = client
    }
    
    // MARK: ParkProvider

    func fetch() {
        
        let isRead = pageIsRead[page]
        if isRead == true { return }
        pageIsRead[page] = true
        
        let previousPage = page
        
        client.readParks(page: page, success: { (parks, next) in
            
            switch previousPage {
            case .begin:
                self.parks = parks
            case .next, .end:
                self.parks += parks
            }
            
            self.page = next
            self.delegate?.didFetch(by: self)
        }) { (error) in
            self.delegate?.didFail(with: error, by: self)
        }
    }
    
    func park(at indexPath: IndexPath) -> Park {
        return parks[indexPath.row]
    }
    
    var hasMoreParks: Bool {
        if page == .end { return false }
        return true
    }
    
    var numberOfParks: Int {
        return parks.count
    }
}

class ParkDetailAPIProvider: ParkDetailProvider {
    
    // MARK: Propert
    
    let client: APIClient
    var parkDetailDelegate: ParkDetailProviderDelagate?
    private var facilities = [Facility]()
    
    
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
        
    }
    
    var facilitiesDescription: String {
        var description = String()
        for i in 0..<facilities.count-1 {
            description += "\(facilities[i].name)" + "、"
        }
        guard let lastFacility = facilities.last else { return description }
        description += lastFacility.name
        return description
    }
    
}
