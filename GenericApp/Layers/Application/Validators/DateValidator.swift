//
//  DateValidator.swift

import Foundation

enum DateValidator: Validator {
    case notEmpty
    case olderThan(futureDate: Date)
    case newerThan(pastDate: Date)

    func validate(_ input: Any?) -> Bool {
        let date = input as? Date
        switch self {
        case .notEmpty:
            guard date != nil else { return false }
        case .olderThan(let futureDate):
            guard let date = date,
                date.compare(futureDate) == .orderedAscending else { return false }
        case .newerThan(let pastDate):
            guard let date = date,
                date.compare(pastDate) == .orderedDescending else { return false }
        }
        return true
    }
}
