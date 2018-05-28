//
//  Facility.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/28.
//  Copyright © 2018年 riverciao. All rights reserved.
//

public struct Facility: Codable {
    
    // MARK: CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case parkName = "parkname"
        case name = "facility_name"
    }
    
    // MARK: Property
    
    public let parkName: String
    public let name: String
}
