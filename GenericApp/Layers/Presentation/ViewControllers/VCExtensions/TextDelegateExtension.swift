//
//  TextDelegateExtension.swift

import UIKit

// MARK: - textfield delegate

extension BaseVC: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentFirstResponder = textField
    }
}

// MARK: - searchField delegate
// no need to specify the UISearchBarDelegate protocol conformance here
// because we already do it in NavigationSearchBar
extension BaseVC {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        currentFirstResponder = searchBar
    }
}

// MARK: - textview delegate to handle placeholder

extension BaseVC: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        currentFirstResponder = textView

        if let textViewWithPlaceholder = textView as? TextViewWithPlaceholder {
            textViewWithPlaceholder.constrainSelectionIfNeccessary()
        }
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        if let textViewWithPlaceholder = textView as? TextViewWithPlaceholder {
            textViewWithPlaceholder.constrainSelectionIfNeccessary()
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let textViewWithPlaceholder = textView as? TextViewWithPlaceholder,
            textViewWithPlaceholder.isShowingPlaceholder() {
            textViewWithPlaceholder.hidePlaceholderText()
            textView.text = text
            return false
        }
        return true
    }

    func textViewDidChange(_ textView: UITextView) {
        if let textViewWithPlaceholder = textView as? TextViewWithPlaceholder {
            textViewWithPlaceholder.showPlaceholderTextIfNeccessary()
        }
    }

    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange) -> Bool {
//        if (URL.scheme?.hasPrefix("myApp-scheme"))! { return !handleDeepLink(URL) }

        let urlString: String
        if url.scheme == "applewebdata" {
            urlString = "http://\(String(describing: url.host))\(url.path)"
        } else {
            urlString = url.absoluteString
        }
        if let newUrl = URL(string: urlString) {
            UIApplication.shared.open(newUrl, options: [String: Any](), completionHandler: nil)
            return false
        }
        return true
    }
}
