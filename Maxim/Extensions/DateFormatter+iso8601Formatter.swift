//
//  DateFormatter+iso8601Formatter.swift
//  Maxim
//
//  Created by Andrew Chersky on 5/26/19.
//  Copyright © 2019 Andrew Chersky. All rights reserved.
//

import Foundation

public final class ISO8601Formatter {
    
    func string(from date: Date, style: DateFormatter.Style) -> String {
        let date = DateFormatter.iso8601Formatter.string(from: date)
        return style == .full ? date : String(date[..<date.index(date.startIndex, offsetBy: 8)])
    }
    
}

public extension DateFormatter {
    
    class var iso8601Formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyyMMdd'T'HHmmssXXXXX"
        return formatter
    }
}
