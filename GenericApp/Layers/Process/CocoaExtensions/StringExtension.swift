//
//  StringExtension.swift
//  MovingLab
//
//  Created by Alex Apprime on 28.05.17.
//  Copyright © 2017 apprime. All rights reserved.
//

import Foundation

extension String {

    /// Get a range of a String by subscripting with a range of Int
    ///
    /// Example:
    ///    let myString = "abcd"
    ///    print(myString[1..<3])
    ///    -- "bc"
    ///
    /// - Parameter rng: a CountableRange
    subscript(rng: Range<Int>) -> String {
        guard rng.lowerBound >= 0 else { return "" }
        return String(self[index(startIndex, offsetBy: rng.lowerBound)..<index(startIndex, offsetBy: min(rng.upperBound, characters.count))])
    }

    /// Get a character as String by subscripting with an Int
    ///
    /// Positive integer values count form the start
    /// while negative values count from the end
    ///
    /// Example:
    ///    let myString = "abcd"
    ///    print(myString[2])
    ///    -- "c"
    ///    print(myString[-1])
    ///    -- "d"
    ///
    /// - Parameter pos: Int
    subscript(pos: Int) -> String {
        let position = pos < 0 ? characters.count + pos: pos
        guard position >= 0, characters.count > position else { return "" }
        return String(self[index(startIndex, offsetBy: position)..<index(startIndex, offsetBy: position + 1)])
    }

    /// Get a substring by providing a start position and a length
    ///
    /// Positive integer values count from the start
    /// while negative values count from the end
    ///
    /// Example:
    ///    let myString = "abcd"
    ///    print(myString.substring(start: 1, length: 2))
    ///    -- "bc"
    ///    print(myString.substring(start: -2, length: 1))
    ///    -- "c"
    ///
    /// - Parameter start: the start index of the substring
    /// - Parameter length: the length of the substring
    func substring(start: Int, length: UInt) -> String {
        let strLength = characters.count
        let startPos = start < 0 ? characters.count + start: start
        guard startPos < strLength else { return "" }
        let lengthAsInt = min(Int(length), strLength - startPos)
        return String(self[index(startIndex, offsetBy: startPos)..<index(startIndex, offsetBy: (startPos + lengthAsInt))])
    }

    /// Get a substring by providing a start position and an end position
    ///
    /// Positive integer values count from the start
    /// while negative values count from the end
    ///
    /// This is the substring FROM 'start' TO 'end'. The character at 'start' is
    /// included, while the character at 'end' is NOT included.
    /// So that 'end' - 'start' is the length of the string
    /// (in the case where start and end are either both > 0 or both < 0)
    ///
    /// Example:
    ///    let myString = "abcd"
    ///    print(myString.substring(start: 1, end: 3))
    ///    -- "bc"
    ///    print(myString.substring(start: -3, end: -2))
    ///    -- "b"
    ///
    /// - Parameter start: the start index of the substring
    /// - Parameter end: the exclisve(!) end index of the substring
    func substring(start: Int, end: Int) -> String {
        let strLength = characters.count
        let startPos = start < 0 ? characters.count + start: start
        guard startPos < strLength else { return "" }
        let endPos = end < 0 ? characters.count + end: end
        guard endPos >= Int(startPos) else { return "" }
        return String(self[index(startIndex, offsetBy: Int(startPos))..<index(startIndex, offsetBy: min(endPos, characters.count))])
    }

    /// This is the equivalent to the Optional's 'nonEmptyString'
    /// so that we can use it interchangeble for Strings and optional Strings
    ///
    /// so instead of requiring something very common in our code like:
    /// ```swift
    /// if let unwrappedString = someOptionalString,
    ///      !unwrappedString.isEmpty {
    ///      ... do something with non empty, unwrapped 'unwrappedString'
    /// }
    /// ```
    ///
    /// we can instead just use:
    /// ```swift
    /// if let stringWithContent = someString.nonEmptyString {
    ///      ... do something with non empty 'someString'
    /// }
    /// ```
    var nonEmptyString: String? {
        if isEmpty { return nil }
        return self
    }

    /**
     Convert NSRange to Swift Text Range

     - parameter objCRange: Objective-C NSRange

     - returns: Swift Text Range representing the same range for this string
     */

    func convertRange(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }

    /**
     Converts string indexes' range to NSRange

     - parameter range: string indexes' range

     - returns: same NSRange represantation for this string
     */

    func NSRangeFromRange(from range: Range<String.Index>) -> NSRange {
        guard let from = range.lowerBound.samePosition(in: utf16),
            let to = range.upperBound.samePosition(in: utf16) else {
                return NSRange(location: 0, length: characters.count)
        }
        let loc = utf16.distance(from: utf16.startIndex, to: from)
        let len = utf16.distance(from: from, to: to)
        return NSRange(location: loc, length: len)
    }

    /**
     Try to convert a string representing a date to a NSDate object

     Start with ISO 8601 format, then our "Conrad German date format", then a timestamp

     - returns: NSDate object corresponding to input string
     */
    var dateValue: Date? {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.ssZZZZZ"
        if let retVal = dateFormatter.date(from: self) { return retVal }

        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZZ"
        if let retVal = dateFormatter.date(from: self) { return retVal }

        dateFormatter.dateFormat = "dd'-'MM'-'yyyy"
        if let retVal = dateFormatter.date(from: self) { return retVal }

        if let intVal = Int(self) { return intVal.dateValue }
        if let doubleVal = Double(self) { return doubleVal.dateValue }

        return nil
    }
}
