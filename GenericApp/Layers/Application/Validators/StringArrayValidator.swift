//
//  StringArrayValidator.swift

import Foundation

enum StringArrayValidator: Validator {
    case notEmpty
    case minLength(length: Int)
    case maxLength(length: Int)
    case contains(subString: String)
    case containsRegexp(regexp: String)

    func validate(_ input: Any?) -> Bool {
        let array = input as? [String]
        switch self {
        case .notEmpty:
            guard let array = array,
                !array.isEmpty else { return false }
            return true
        case .minLength(let length):
            guard let array = array,
                !array.isEmpty else { return false }
            return array.count >= length
        case .maxLength(let length):
            guard let array = array,
                !array.isEmpty else { return true }
            return array.count <= length
        case .contains(let subString):
            return array?.joined().contains(subString) ?? false
        case .containsRegexp(let regexp):
            guard array?.joined().range(of: regexp,
                              options: [.regularExpression, .caseInsensitive],
                              range: nil,
                              locale: nil) != nil else { return false }
            return true
        }
    }
}
