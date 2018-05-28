//
//  Page.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/26.
//  Copyright © 2018年 riverciao. All rights reserved.
//

enum Page {
    case begin
    case next(Int)
    case end
    
    static let numberOfParksInPage = 15
}

extension Page: Equatable {
    static func ==(lhs: Page, rhs: Page) -> Bool {
        switch (lhs, rhs) {
        case (.begin, .begin):
            return true
        case (.next(let lhsIndex), .next(let rhsIndex)):
            return lhsIndex == rhsIndex
        case (.end, .end):
            return true
        default:
            return false
        }
    }
}

extension Page: Hashable {
    var hashValue: Int {
        return "\(self)".hashValue
    }
}

