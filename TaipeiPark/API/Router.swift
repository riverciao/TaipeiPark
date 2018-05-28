//
//  Router.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/25.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation

enum Router {
    
    case readParks(forAmount: Int, fromLastReadIndex: Int?)
    case readFacility(byParkName: String)
    case readSpot(byParkName: String)
    
    static let baseURL = URL(string: "https://beta.data.taipei/opendata/datalist/apiAccess")!
    
    var queryItems: [URLQueryItem] {
        
        switch self {
        case .readParks(let limit, let offset):
            var queryParameters: [String : String] = [
                "scope": "resourceAquire",
                "rid": "8f6fcb24-290b-461d-9d34-72ed1b3f51f0",
                "limit": String(limit)
            ]
            guard let offset = offset else {
                return queryParameters.map { URLQueryItem(name: $0, value: $1)}
            }
            queryParameters["offset"] =  String(offset)
            return queryParameters.map { URLQueryItem(name: $0, value: $1)}
            
        case .readFacility(let parkName):
            let queryParameters: [String : String] = [
                "scope": "resourceAquire",
                "rid": "97d0cf5c-dc1f-4b5e-8d02-a07e7cc82db7",
                "q": parkName
            ]
            return queryParameters.map { URLQueryItem(name: $0, value: $1)}
       
        case .readSpot(let parkName):
            let queryParameters: [String : String] = [
                "scope": "resourceAquire",
                "rid": "bf073841-c734-49bf-a97f-3757a6013812",
                "q": parkName
            ]
            return queryParameters.map { URLQueryItem(name: $0, value: $1)}
         }
    }
    var httpMethod: HTTPMethod {
        return .get
    }
}

// MARK: URLRequestConvertible

extension Router: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURL.appendingQueryItemsComponent(queryItems)
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue

        return request
    }
}


