//
//  ParkId.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/6.
//  Copyright © 2018年 riverciao. All rights reserved.
//

public struct ParkId {
    public var rawValue: String {
        didSet {
            intRawValue = Int(rawValue)
        }
    }
    public var intRawValue: Int?
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension ParkId: Equatable {
    public static func ==(lhs: ParkId, rhs: ParkId) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
