//
//  Park.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/25.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation
import CoreLocation

enum JSONError: Error {
    case notObject
    case missingValueForKey(String)
    case invalidValueForKey(String)
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
    public let coordinate: CLLocationCoordinate2D
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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.openTime = try container.decode(String?.self, forKey: .openTime)
        self.introduction = try container.decode(String.self, forKey: .introduction)
        self.imageURL = try container.decode(String.self, forKey: .imageURL)
        self.administrativeArea = try container.decode(String.self, forKey: .administrativeArea)
        self.address = try container.decode(String.self, forKey: .address)
        self.parkType = try container.decode(String.self, forKey: .parkType)
        
        let latitudeString = try container.decode(String.self, forKey: .latitude)
        let longitudeString = try container.decode(String.self, forKey: .longitude)
        guard let latitude = Double(latitudeString) else { throw JSONError.invalidValueForKey(CodingKeys.latitude.rawValue) }
        guard let longitude = Double(longitudeString) else { throw JSONError.invalidValueForKey(CodingKeys.longitude.rawValue)}
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // MARK: Encodable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(openTime, forKey: .openTime)
        try container.encode(introduction, forKey: .introduction)
        try container.encode(imageURL, forKey: .imageURL)
        try container.encode(String(coordinate.latitude), forKey: .latitude)
        try container.encode(String(coordinate.longitude), forKey: .longitude)
        try container.encode(administrativeArea, forKey: .administrativeArea)
        try container.encode(address, forKey: .address)
        try container.encode(parkType, forKey: .parkType)
    }
}


