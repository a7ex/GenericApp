//
//  TextViewWithPlaceholder.swift

import UIKit

/**
 
 1.) Use the Runtime Variables in the Storyboard for the placeholder text
 2.) Set the delegate of this textView to a class which handles the following delegate calls:
 3a.) Either subclass "BaseVC"
 or
 3b.) implement the following delegate calls in your delegate:
 
 // MARK: - textview delegate to handle placeholder
 ```swift
 func textViewDidBeginEditing(textView:UITextView) {
 if let textViewWithPlaceholder = textView as? TextViewWithPlaceholder {
 textViewWithPlaceholder.constrainSelectionIfNeccessary()
 }
 }
 ```
 ```swift
 func textViewDidChangeSelection(textView:UITextView) {
 if let textViewWithPlaceholder = textView as? TextViewWithPlaceholder {
 textViewWithPlaceholder.constrainSelectionIfNeccessary()
 }
 }
 ```
 ```swift
 func textView(textView:UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
 if let textViewWithPlaceholder = textView as? TextViewWithPlaceholder
 where textViewWithPlaceholder.isShowingPlaceholder() {
 textView.text = text
 return false
 }
 }
 return true
 }
 ```
 ```swift
 func textViewDidChange(textView:UITextView) {
 if let textViewWithPlaceholder = textView as? TextViewWithPlaceholder {
 textViewWithPlaceholder.showPlaceholderTextIfNeccessary()
 }
 }
 ```
 IMPORTANT NOTE:
 
 A subclass of BaseVC doesn't need to implement these, BUT in case it implements those methods for other purposes, it must forward the call to super in order for this class to work as expected
 
 */
class TextViewWithPlaceholder: UITextView {

    @IBInspectable var placeholder: String = "Enter text here..." {
        didSet {
            if currentText == nil {
                showPlaceholderText()
            } else if currentText?.isEmpty == true {
                showPlaceholderText()
            }
        }
    }

    @IBInspectable var placeholderTextColor: UIColor = UIColor.lightGray {
        didSet {
            showPlaceholderTextIfNeccessary()
        }
    }

    override var text: String? {
        didSet {
            textDidChange()
        }
    }

    override var attributedText: NSAttributedString? {
        didSet {
            attributedTextDidChange()
        }
    }

    var currentText: String? {
        return showingPlaceholder ? "" : text
    }

    private final var showingPlaceholder = false
    private final var originalTextColor: UIColor?

    override func awakeFromNib() {
        super.awakeFromNib()

        assert(delegate != nil, "TextViewWithPlaceholder requires a delegate to be set and route the text editing events to the TextViewWithPlaceholder class!")

        if let text = text,
            text.isEmpty,
            !placeholder.isEmpty {
            showPlaceholderText()
        }
    }

    func constrainSelectionIfNeccessary() {
        if isShowingPlaceholder() {
            selectedRange = NSRange(location: 0, length: 0)
        }
    }

    func isShowingPlaceholder() -> Bool {
        return showingPlaceholder
    }

    func hidePlaceholderText() {
        if isShowingPlaceholder() {
            super.text = ""
            showingPlaceholder = false
            if originalTextColor != nil {
                textColor = originalTextColor
            }
        }
    }

    func showPlaceholderText() {
        // that's a stupid hack, but otherwise the formatting and NSLink would persist, if any
        super.attributedText = NSAttributedString(string: "x", attributes: [NSAttributedStringKey.font: super.font ?? UIFont.systemFont(ofSize: 10)])

        super.text = placeholder
        if originalTextColor == nil {
            originalTextColor = textColor ?? UIColor.black
        }
        textColor = placeholderTextColor
        showingPlaceholder = true
        selectedRange = NSRange(location: 0, length: 0)
    }

    func showPlaceholderTextIfNeccessary() {
        if let currentText = text,
            currentText.isEmpty,
            !placeholder.isEmpty {
            showPlaceholderText()
        }
    }

    private final func textDidChange() {
        if let currenttext = text,
            isShowingPlaceholder(),
            !currenttext.isEmpty {
            hidePlaceholderText()
        }

        if !placeholder.isEmpty,
            let currenttext = text,
            currenttext.isEmpty,
            !isShowingPlaceholder() {
            showPlaceholderText()
        }
    }

    private final func attributedTextDidChange() {
        if let attrText = attributedText,
            isShowingPlaceholder(),
            !attrText.string.isEmpty {
            hidePlaceholderText()
        }

        if !placeholder.isEmpty,
            let attrText = attributedText,
            attrText.string.isEmpty,
            !isShowingPlaceholder() {
            showPlaceholderText()
        }
    }
}
