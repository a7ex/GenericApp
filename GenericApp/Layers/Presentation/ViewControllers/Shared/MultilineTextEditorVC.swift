//
//  MultilineTextEditorVC.swift

import UIKit
import AudioToolbox

/// MultilineTextEditorVC controls a simple view with an editable TextView
/// The TextView supports a placeholder and also optionally
/// a maximum number of allowed characters, if the instance variable
/// 'maximumNumberOfCharactersAllowed' is defined

class MultilineTextEditorVC: BaseVC {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var textView: TextViewWithPlaceholder!
    @IBOutlet weak var statusText: UILabel!
    
    // MARK: - Instance variables
    
    /// Limit the number of allowed characters by setting this
    /// variable to something else than the max Integer
    /// Not only this will not allow to enter more than the allowed number of characters
    /// but also this VC will then display a status text at the bottom right of the view
    var maximumNumberOfCharactersAllowed = UInt(Int.max)
    
    /// Define a placeholder string as prompt
    /// If empty, then no placeholderString is displayed
    var placeHolderString = ""
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = originalString
        textView.placeholder = placeHolderString
        updateStatusTextFor(contentString: originalString)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if textView.canBecomeFirstResponder {
            textView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        doneClosure?(textView?.currentText ?? "", originalString)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Convenience initializer
    
    class func initWithString(_ initialString: String, doneClosure: @escaping((String, String) -> ())) -> MultilineTextEditorVC {
        let vc = multiLineTextEditor()
        vc.originalString = initialString
        vc.doneClosure = doneClosure
        return vc
    }
    
    //MARK: - Keyboard handling
    
    func hidesKeyboardOnTap() -> Bool {
        return false
    }
    
    func prepareKeyboardShowAnimation(_ notification:Foundation.Notification) {
        if let constr = statusText?.ffs_layoutConstraintWithAttribute(.bottom) {
            storeConstraintConstantForKeyboardAnimation(constr)
            constr.constant = view.frame.size.height - keyboardEndframe.origin.y
        }
    }
    
    // MARK: - Text delegate
    
    override func textView(_ textView:UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let returnValue = super.textView(textView, shouldChangeTextIn: range, replacementText: text)
        let newValue = textView.text!.replacingCharacters(in: textView.text!.convertRange(from: range)!, with:text)
        if newValue.characters.count > Int(maximumNumberOfCharactersAllowed) {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            return false
        }
        returnValue ? updateStatusTextFor(contentString: newValue): updateStatusTextFor(contentString: textView.text ?? "")
        return returnValue
    }
    
    // MARK: - Private
    
    private var originalString: String = ""
    private var doneClosure: ((String, String) -> ())?
    
    
    private class func multiLineTextEditor() -> MultilineTextEditorVC {
        let mainStoryboard = UIStoryboard(name: Constants.storyBoardName, bundle: nil)
        return (mainStoryboard.instantiateViewController(withIdentifier: Constants.OriginatingClassName) as? MultilineTextEditorVC)!
    }
    
    private func updateStatusTextFor(contentString: String) {
        guard maximumNumberOfCharactersAllowed != UInt(Int.max) else {
            statusText.text = ""
            return
        }
        statusText.text = "\(contentString.characters.count)/\(maximumNumberOfCharactersAllowed)"
    }
    
    private struct Constants {
        static let storyBoardName = "Main"
        static let OriginatingClassName = "MultilineTextEditorVC"
    }
}
