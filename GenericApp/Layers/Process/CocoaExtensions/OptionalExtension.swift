//
//  OptionalExtension.swift

import Foundation

/// Extend an Optional which wraps a String value type

extension Optional where Wrapped: ExpressibleByStringLiteral {

    /// Extend an Optional which wraps a String value type
    /// so that we can check in one go, whether it is nil OR isEmpty
    ///
    /// so instead of requiring something very common in our code like:
    /// ```swift
    /// if let unwrappedString = someOptionalString,
    ///      !unwrappedString.isEmpty {
    ///      ... do something if unwrapped 'unwrappedString' is not nil and not empty
    /// }
    /// ```
    ///
    /// we can instead just use:
    /// ```swift
    /// if someOptionalString.hasNonEmptyStringContent {
    ///      ... do something if unwrapped 'unwrappedString' is not nil and not empty
    /// }
    /// ```
    var hasNonEmptyStringContent: Bool {
        if case let .some(value) = self as? String {
            return !value.isEmpty
        }
        return false
    }

    /// Extend an Optional which wraps a String value type
    /// so that we can assign only if the string is not nil and not empty
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
    /// if let unwrappedString = someOptionalString.nonEmptyString {
    ///      ... do something with non empty, unwrapped 'unwrappedString'
    /// }
    /// ```
    var nonEmptyString: String? {
        if self.hasNonEmptyStringContent { return self as? String }
        return nil
    }

    /// Extend an Optional which wraps a String value type
    /// so that we can assign only if the string is not nil and not empty
    /// where 'empty' is defined here only after trimming the provided Characters
    /// This allows us to also treat strings like " " or "\t\t \n" as empty
    ///
    /// Usage:
    /// ```swift
    /// if let visibleString = someOptionalString.nonEmptyString(trimmingChars: CharacterSet.whitespacesAndNewlines) {
    ///      ... do something with non empty, visible, unwrapped 'unwrappedString'
    /// }
    /// ```
    func nonEmptyString(trimmingChars: CharacterSet) -> String? {
        if case let .some(value) = self as? String {
            let trimmed = value.trimmingCharacters(in: trimmingChars)
            if trimmed.isEmpty { return nil }
            return value
        }
        return nil
    }

    /// Extend an Optional which wraps a String value type
    /// so that we can assign only if the string is not nil and not empty
    /// where 'empty' is defined here only after trimming whiteSpaceAndNewline characters
    ///
    /// Usage:
    /// ```swift
    /// if let visibleString = someOptionalString.printableNonEmptyString {
    ///      ... do something with non empty, visible, unwrapped 'unwrappedString'
    /// }
    /// ```
    ///
    /// This is just a convenience property to apply 
    /// someOptionalString.nonEmptyString(trimmingChars: CharacterSet.whitespacesAndNewlines)
    ///
    var printableNonEmptyString: String? {
        return self.nonEmptyString(trimmingChars: CharacterSet.whitespacesAndNewlines)
    }
}
