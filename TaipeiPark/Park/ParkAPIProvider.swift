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
    
    // MARK: Init
    
    init(client: APIClient) {
        self.client = client
    }
    
    // MARK: ParkProvider

    func fetch() {
        
        let previousPage = page
        
        client.readParks(page: page, success: { (parks, next) in
            
            switch previousPage {
            case .begin:
                self.parks = parks
            case .next(let indexLastRead):
                if self.numberOfParks == indexLastRead {
                    self.parks += parks
                }
            case .end:
                self.parks += parks
            }
            
            print("OO: count-\(parks.count), page \(next)")
            print("OO: toalcount\(self.parks.count)")

            
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