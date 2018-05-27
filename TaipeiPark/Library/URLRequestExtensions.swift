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

//extension URLRequestConvertible {
//    var urlRequest: URLRequest? {
//        return try? asURLRequest()
//    }
//}

extension URLRequest: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        return self
    }
}

//extension URLSession {
//    func request(_ urlRequest: URLRequestConvertible) -> URLRequest {
//        do {
//            return try urlRequest.asURLRequest()
//        } catch {
//            // throw error to response.result
//        }
//    }
//}

extension URLRequest {
    func responseData(urlSession: URLSession, _ completion: @escaping (DataResponse) -> Void) {
        let datatask = urlSession.dataTask(with: self) { (data, response, error) in
            
            if let error = error {
                let result = Result.failure(error)
                completion(DataResponse(result: result))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                switch statusCode {
                case 200: break
                default:
                    let result = Result.failure(HTTPError.statusCodeNotNormal(statusCode))
                    completion(DataResponse(result: result))
                    return
                }
            }
            
            guard let data = data else {
                let result = Result.failure(APIError.missingData)
                completion(DataResponse(result: result))
                return
            }
            
            let result = Result.sucess(data)
            completion(DataResponse(result: result))
        }
        
        datatask.resume()
    }
}

struct DataResponse {
    var result: Result
    
    init(result: Result) {
        self.result = result
    }
}

enum Result {
    case sucess(Data)
    case failure(Error)
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
