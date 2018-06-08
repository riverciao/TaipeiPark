//
//  MapParkAPIProvider.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/8.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation
import UIKit

class LocationParkAPIProvider: ParkProvider {
    
    // MARK: Property
    
    let client: APIClient
    var delegate: ParkProviderDelegate?
    var parks = [Park]()
    private var page: Page = .begin
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
        
        client.readParks(page: page, numberOfParksInPage: 800, success: { (parks, next) in
            
            switch previousPage {
            case .begin:
                self.parks = parks
            case .next, .end:
                self.parks += parks
            }
            
            self.page = next
            self.delegate?.didFetch(by: self)
            
            print("Count: \(parks.count), page: \(self.page)")
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
