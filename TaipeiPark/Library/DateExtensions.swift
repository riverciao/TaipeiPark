//
//  DateExtensions.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/8.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation

extension Date {
    
    /// pass in time string format like "00:00~24:00" to return if self is in open time
    func isInOpenTime(_ openTime: String) -> Bool {
        if let dates = parseTimeRangeToDates(from: openTime) {
            if self >= dates[0] && self < dates[1] {
                return true
            }
        }
        return false
    }
    
    private func hourInDayForm0To23(string: String) -> String {
        if string == "24:00" {
            return "23:59"
        }
        return string
    }
    
    /// pass in time string format like "00:00~24:00" to return 2 time in Date type
    private func parseTimeRangeToDates(from timeRangeString: String) -> [Date]? {
        let openTimeStringCharacters = Array(timeRangeString)
        
        // MARK: Seperate 2 time string
        var startTimeStringArray = [Character]()
        var closeTimeStringArray = [Character]()
        if let separaterIndex = openTimeStringCharacters.index(of: "~") {
            for i in openTimeStringCharacters.indices {
                if i < separaterIndex {
                    startTimeStringArray.append(openTimeStringCharacters[i])
                }
                if i > separaterIndex {
                    closeTimeStringArray.append(openTimeStringCharacters[i])
                }
            }
        }
        var startTimeString = hourInDayForm0To23(string: String(startTimeStringArray))
        var closeTimeString = hourInDayForm0To23(string: String(closeTimeStringArray))
        
        // MARK: Add self year/month/day in to compare so that we can compare open time in the same day
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.string(from: self)
        startTimeString += date
        closeTimeString += date
        formatter.dateFormat = "HH:mmyyyyMMdd"
        
        // MARK: Parse from String to Date
        guard let startTime = formatter.date(from: startTimeString),
            let closeTime = formatter.date(from: closeTimeString) else { return nil }
        return [startTime, closeTime]
    }
}
