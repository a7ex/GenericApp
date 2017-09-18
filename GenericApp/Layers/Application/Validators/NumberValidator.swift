//
//  NumberValidator.swift

import Foundation

enum NumberValidator: Validator {
    case notEmpty
    case greaterThan(refValue: Double)
    case lowerThan(refValue: Double)
    case equals(refValue: Double)

    func validate(_ input: Any?) -> Bool {
        var number = input as? Double
        if number == nil,
            let intNumber = input as? Int {
            number = Double(intNumber)
        }
        if number == nil,
            let numString = input as? String {
            number = Double(numString)
        }
        switch self {
        case .notEmpty:
            guard number != nil else { return false }
        case .greaterThan(let refValue):
            guard let number = number,
                 number > refValue else { return false }
        case .lowerThan(let refValue):
            guard let number = number,
                number < refValue else { return false }
        case .equals(let refValue):
            guard let number = number,
                number == refValue else { return false }
        }
        return true
    }
}
