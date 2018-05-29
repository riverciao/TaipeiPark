//
//  Spot.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/29.
//  Copyright © 2018年 riverciao. All rights reserved.
//

public struct Spot: Codable {
    
    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case parkName = "ParkName"
        case name = "Name"
        case openTime = "OpenTime"
        case introduction = "Introduction"
        case imageURL = "Image"
    }
    
    // MARK: Property
    
    public let parkName: String
    public let name: String
    public let openTime: String
    public let introduction: String
    public let imageURL: String
}
