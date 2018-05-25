//
//  URLRequestExtensions.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/25.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation

protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}

extension URLRequestConvertible {
    var urlRequest: URLRequest? {
        return try? asURLRequest()
    }
}

extension URLRequest: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        return self
    }
}

extension URL {
    func appendingQueryItemsComponent(_ queryItems: [URLQueryItem]) throws -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: false) else { throw  URLError.invalidURL }
        components.queryItems = queryItems
        
        return (components.url)!
    }
}

enum URLError: Error {
    case invalidURL
    case missingRequest
}

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
