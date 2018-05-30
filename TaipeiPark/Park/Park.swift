//
//  Park.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/25.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation
import UIKit
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
        case imageURLString = "Image"
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
        public static let count = "count"
    }
    
    // MARK: Property
    
    public let name: String
    public let openTime: String?
    public let introduction: String
    public let imageURLString: String
    public let coordinate: CLLocationCoordinate2D
    public let administrativeArea: String
    public let address: String
    public let parkType: String
    public var image: UIImage?
    
    public typealias ParksData = Data
    public typealias CountOfParks = Int
    
    public static func parseToDecodableResults(_ data: Data) throws -> (ParksData, CountOfParks) {
        typealias Object = [String: Any]

        let json = try JSONSerialization.jsonObject(with: data)
        guard let object = json as? Object else { throw JSONError.notObject }
        guard let result = object[Schema.result] as? Object else { throw JSONError.missingValueForKey(Schema.result) }
        guard let parks = result[Schema.results] as? [Object] else { throw JSONError.missingValueForKey(Schema.results) }
        let parksData = try JSONSerialization.data(withJSONObject: parks)
        
        guard let countOfParks = result[Schema.count] as? Int else {
            throw JSONError.missingValueForKey(Schema.count)
        }
        
        return (parksData, countOfParks)
    }
    
    
    // MARK: Decodable
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.openTime = try container.decode(String?.self, forKey: .openTime)
        self.introduction = try container.decode(String.self, forKey: .introduction)
        self.imageURLString = try container.decode(String.self, forKey: .imageURLString)
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
        try container.encode(imageURLString, forKey: .imageURLString)
        try container.encode(String(coordinate.latitude), forKey: .latitude)
        try container.encode(String(coordinate.longitude), forKey: .longitude)
        try container.encode(administrativeArea, forKey: .administrativeArea)
        try container.encode(address, forKey: .address)
        try container.encode(parkType, forKey: .parkType)
    }
}

// MARK: Image URL

public extension Park {
    public var imageURL: URL {
        return URL(string: imageURLString)!
    }
}



