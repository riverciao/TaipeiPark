//
//  DateExtensions.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/8.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation

extension Date {
    
    /// pass in time string format like "00:00~24:00" to return if now is in open time
    func isNowInOpenTime(_ openTime: String) -> Bool {
        
        /// pass in time string format like "00:00~24:00" to return 2 time date
        func parseToDates(from openTimeString: String) -> [Date]? {
            let openTimeStringCharacters = Array(openTimeString)
            
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
            let startTimeString = String(startTimeStringArray)
            let closeTimeString = String(closeTimeStringArray)
            
            // MARK: Parse from String to Date
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm"
            guard let startTime = formatter.date(from: startTimeString),
                let closeTime = formatter.date(from: closeTimeString) else { return nil }
            return [startTime, closeTime]
        }
        
        guard let dates = parseToDates(from: openTime) else { return false }
        let now = Date()
        if now >= dates[0] && now <= dates[1] {
            return true
        }
        return false
    }
}
