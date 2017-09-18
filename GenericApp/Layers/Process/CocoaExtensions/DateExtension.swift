//
//  DateExtension.swift
//  MovingLab
//
//  Created by Alex Apprime on 18.06.17.
//  Copyright © 2017 apprime. All rights reserved.
//

import Foundation

extension Date {
    /**
     Convert an NSDate object to a string representing a date in ISO 8601 format (default)

     - parameter dateObj: NSDate object
     - parameter format: Format string for date (default is ISO 8601 format)

     - returns: String representing a date in the chosen format (default: ISO 8601)
     */
    func stringValue(withFormat format: String="yyyy-MM-dd'T'HH:mm:ss.sZZZZZ") -> String? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: self)
    }

    /**
     Convert an NSDate object to a localized readable date string

     - parameter dateObj: NSDate object

     - returns: String representing a date as human readable string
     */
    func displayString(dateStyle: DateFormatter.Style? = nil,
                       timeStyle: DateFormatter.Style? = nil) -> String? {
            let dateFormatter = DateFormatter()
            configureDateFormatter(dateFormatter, dateStyle: dateStyle, timeStyle: timeStyle)
            return dateFormatter.string(from: self)
    }

    /**
     Normalize a date to a specified hour of the day

     - parameter hour: Integer value defining a 24 hour time

     - returns: Date object, normalized to that hour
     */
    func normalize(to hour: Int = 0, in calendar: Calendar = Calendar.current) -> Date {
        let unitFlags = Set([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year])
        let dateComponents = calendar.dateComponents(unitFlags, from: self)
        guard let normalizedDate = calendar.date(from: dateComponents) else {
            return self
        }
        return calendar.date(byAdding: DateComponents(hour: hour), to: normalizedDate) ?? normalizedDate
    }

    /// Floor the seconds of a date
    ///
    /// - Returns: new Date object, where the nanoseconds are 000
    func stripSecondFractions() -> Date {
        let calendar = Calendar.current
        let unitFlags = Set([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second, Calendar.Component.timeZone])
        let components = calendar.dateComponents(unitFlags, from: self)
        return calendar.date(from: components) ?? self
    }

    private func configureDateFormatter(_ dateFormatter: DateFormatter,
                                        dateStyle: DateFormatter.Style? = nil,
                                        timeStyle: DateFormatter.Style? = nil) {
        dateFormatter.dateStyle = dateStyle ?? .long
        dateFormatter.timeStyle = timeStyle ?? .none
//        dateFormatter.locale = Locale.current
    }

    var doubleValue: Double {
        return timeIntervalSince1970 as Double
    }
    var intValue: Int {
        return Int(timeIntervalSince1970)
    }
}
