//
//  UITextFieldValidationExtension.swift

import UIKit

extension UIViewController {
    final func validate(field: UITextField?, with validator: Validator, errorMessage: String) -> String? {
        guard let text = field?.validate(with: validator) else {
            if !errorMessage.isEmpty {
                showSimpleAlert(errorMessage)
            }
            return nil
        }
        return text
    }
    final func validate(inputString: String?, with validator: Validator) -> String? {
        guard let text = inputString,
            validator.validate(text) else { return nil }
        return text
    }
}

extension UITextField {
    func validate(with validator: Validator) -> String? {
        guard let text = text,
            validator.validate(text) else { return nil }
        return text
    }
}
