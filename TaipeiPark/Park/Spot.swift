//
//  Spot.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/29.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation
import UIKit

public struct Spot: Codable {
    
    // MARK: CodingKeys
    enum CodingKeys: String, CodingKey {
        case parkName = "ParkName"
        case name = "Name"
        case openTime = "OpenTime"
        case introduction = "Introduction"
        case imageURLString = "Image"
    }
    
    // MARK: Property
    
    public let parkName: String
    public let name: String
    public let openTime: String
    public let introduction: String
    public let imageURLString: String
    public var image: UIImage?
}

extension Spot {
    var imageURL: URL? {
        return URL(string: imageURLString)
    }
}
