//
//  APIClient.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/26.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation

enum APIError: Error {
    case missingData
}

struct APIClient {
    let urlSession = URLSession.shared
}

extension APIClient: ParkAPIClient {
    
    enum IndexError: Error {
        case reachEndPage
    }
    
    func readParks(page: Page, success: @escaping ParkAPIClient.ReadParksSuccess, failure: ParkAPIClient.ReadParksFailure?) {
        
        var paging: Int = 0
        
        switch page {
        case .begin:
            break
        case .next(let lastReadIndex):
            paging = lastReadIndex
        case .end:
            failure?(IndexError.reachEndPage)
            return
        }
        
        let numberOfParksInPage = Page.numberOfParksInPage
        let router = Router.readParks(forAmount: numberOfParksInPage, fromLastReadIndex: paging)
        
        do {
            let request = try router.asURLRequest()
            request.responseData(urlSession: urlSession, { (dataResponse) in
                switch dataResponse.result {
                    
                case .sucess(let data):
                    do {
                        let (parksData, numberOfParks) = try Park.parseToDecodableParks(data)
                        let parks = try JSONDecoder().decode([Park].self, from: parksData)
                        
                        var next: Page = .end
                        let nextPageEndIndex = paging + numberOfParksInPage
                        if nextPageEndIndex < numberOfParks {
                            next = .next(paging + numberOfParksInPage)
                        }
                        success(parks, next)
                    } catch {
                        failure?(error)
                    }
                    
                case .failure(let error):
                    failure?(error)
                }
            })
        } catch {
            failure?(error)
        }
    }
}

extension APIClient: FacilityAPIClient {
    func readFacilities(by parkName: String, success: @escaping FacilityAPIClient.ReadFacilitySuccess, failure: FacilityAPIClient.ReadFacilityFailure?) {
        
        let router = Router.readFacility(byParkName: parkName)
        
        do {
            let request = try router.asURLRequest()
            request.responseData(urlSession: urlSession, { (dataResponse) in
                
                switch dataResponse.result {
                case .sucess(let data):
                    
                    do {
                        let (facilitiesData, _) = try Park.parseToDecodableParks(data)
                        let facilities = try JSONDecoder().decode([Facility].self, from: facilitiesData)
                        success(facilities)
                    } catch {
                        failure?(error)
                    }
                    
                case .failure(let error):
                    failure?(error)
                }
            })
        } catch {
            failure?(error)
        }
    }
}

