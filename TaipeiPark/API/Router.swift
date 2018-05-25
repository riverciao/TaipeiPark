//
//  Router.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/25.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation

enum Router {
    
    case readParks
    
    static let baseURL = URL(string: "https://beta.data.taipei/opendata/datalist/apiAccess")!
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .readParks:
            let queryParameters: [String : String] = [
                "scope": "resourceAquire",
                "rid": "8f6fcb24-290b-461d-9d34-72ed1b3f51f0",
            ]
            return queryParameters.map { URLQueryItem(name: $0, value: $1)}
        }
    }
    var httpMethod: HTTPMethod {
        switch self {
        case .readParks:
            return .get
        }
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


