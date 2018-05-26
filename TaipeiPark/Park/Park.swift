//
//  Park.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/25.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation

enum JSONError: Error {
    case notObject
    case missingValueForKey(String)
}

public struct Park: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case name = "ParkName"
        case openTime = "OpenTime"
        case introduction = "Introduction"
        case imageURL = "Image"
        case latitude = "Longitude"
        case longitude = "Latitude"
        case administrativeArea = "AdministrativeArea"
        case address = "Location"
        case parkType = "ParkType"
    }
    
    // MARK: Schema
    
    public struct Schema {
        public static let result = "result"
        public static let results = "results"
    }
    
    // MARK: Property
    
    public let name: String
    public let openTime: String?
    public let introduction: String
    public let imageURL: String
    public let latitude: String
    public let longitude: String
    public let administrativeArea: String
    public let address: String
    public let parkType: String
    
    public static func parseToDecodableParks(_ data: Data) throws -> Data {
        typealias Object = [String: Any]

        let json = try JSONSerialization.jsonObject(with: data)
        guard let object = json as? Object else { throw JSONError.notObject }
        guard let result = object[Schema.result] as? Object else { throw JSONError.missingValueForKey(Schema.result) }
        guard let parks = result[Schema.results] as? [Object] else { throw JSONError.missingValueForKey(Schema.results) }
        let data = try JSONSerialization.data(withJSONObject: parks)
        
        return data
    }
    
    
    // MARK: Decodable
    
}


