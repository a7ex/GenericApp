//
//  TextValidator.swift

import Foundation

enum TextValidator: Validator {
    case notEmpty
    case minLength(length: Int)
    case maxLength(length: Int)
    case contains(subString: String)
    case containsRegexp(regexp: String)
    case validEmail

    func validate(_ input: Any?) -> Bool {
        let text = input as? String
        switch self {
        case .notEmpty:
            guard let text = text,
                !text.isEmpty else { return false }
            return true
        case .minLength(let length):
            guard let text = text,
                !text.isEmpty else { return false }
            return text.characters.count >= length
        case .maxLength(let length):
            guard let text = text,
                !text.isEmpty else { return true }
            return text.characters.count <= length
        case .contains(let subString):
            return text?.contains(subString) ?? false
        case .containsRegexp(let regexp):
            guard text?.range(of: regexp,
                              options: [.regularExpression, .caseInsensitive],
                              range: nil,
                              locale: nil) != nil else { return false }
            return true
        case .validEmail:
            return text?.contains("@") ?? false
        }
    }
}
