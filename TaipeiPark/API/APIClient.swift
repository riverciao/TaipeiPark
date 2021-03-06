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
    case statusCodeNotNormal(Int)
}

struct APIClient {
    let urlSession = URLSession.shared
}

extension APIClient: ParkAPIClient {
    
    enum IndexError: Error {
        case reachEndPage
    }
    
    func readParks(page: Page, numberOfParksInPage: Int = Page.numberOfParksInPage, success: @escaping ReadParksSuccess, failure: ReadParksFailure?) {
        
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
        
        let router = Router.readParks(forAmount: numberOfParksInPage, fromLastReadIndex: paging)
        
        do {
            let request = try router.asURLRequest()
            request.responseData(urlSession: urlSession, { (dataResponse) in
                switch dataResponse.result {
                    
                case .success(let data):
                    do {
                        let (parksData, numberOfParks) = try Park.parseToDecodableResults(data)
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

extension APIClient: ParkDetailAPIClient {
    
    // MARK: Read Facility
    
    func readFacilities(by parkName: String, success: @escaping ReadFacilitySuccess, failure: ReadFacilityFailure?) {
        
        let router = Router.readFacility(byParkName: parkName)
        
        do {
            let request = try router.asURLRequest()
            request.responseData(urlSession: urlSession, { (dataResponse) in
                
                switch dataResponse.result {
                case .success(let data):
                    
                    do {
                        let facilitiesData = try Park.parseToDecodableData(data)
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
    
    // MARK: Read Spot
    
    func readSpots(by parkName: String, success: @escaping ReadSpotSuccess, failure: ReadSpotFailure?) {
        
        let router = Router.readSpot(byParkName: parkName)
        
        do {
            let request = try router.asURLRequest()
            request.responseData(urlSession: urlSession, { (dataResponse) in
                
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let decodableSpots = try Park.parseToDecodableData(data)
                        let spots = try JSONDecoder().decode([Spot].self, from: decodableSpots)
                        success(spots)
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

