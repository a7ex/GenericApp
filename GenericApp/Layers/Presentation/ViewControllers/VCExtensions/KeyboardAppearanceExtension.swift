//
//  KeyboardAppearanceExtension.swift

import UIKit

// MARK: - Override these in your subclass
// ...if necessary
protocol KeyboardHandling {
    func hidesKeyboardOnTap() -> Bool
}

extension KeyboardHandling {
    /**
     Override this method to get an event, BEFORE the keyboard appears
     
     Note, that the frame, which the keyboard will appear in, will already be available as self.keyboardEndframe
     in the coordinate space of this viewcontrollers view
     and there is no need to get it from the notification object anymore
     
     - parameter notification: the notification object from the OS
     */
    func prepareKeyboardChangeAnimation(_ notification: Notification) {
    }
    
    /**
     Override this method to get an event, AFTER the keyboard changed (show or hide)
     
     Note, that the frame, which the keyboard will appear in, will already be available as self.keyboardEndframe
     in the coordinate space of this viewcontrollers view
     and there is no need to get it from the notification object anymore
     
     - parameter notification: the notification object from the OS
     */
    func keyboardChangeAnimationCompleted(_ notification: Notification) {
    }
    
    /**
     Whether or not a tap gesture is added to the viewcontrollers view to enable a tap in the "off" to dismiss the keyboard
     
     Override this in subclass to prevent backgropund tap to hide keyboard
     
     - returns: Boolean whether or not the tap gesture shall be added
     */
    func hidesKeyboardOnTap() -> Bool {
        return true
    }
}

extension BaseVC: KeyboardHandling {

    /**
     Override this method to get an event, DURING the keyboard change (show or hide) animation
     So this is the right place to animate views "alongside" the keyboard animation
     
     IMPORTANT NOTE: Do not forget to call this method on super, unless you want to prevent the update of constraint changes (layoutIfNeeded)
     Note, that the frame, which the keyboard will appear in, will already be available as self.keyboardEndframe
     in the coordinate space of this viewcontrollers view
     and so there is no need to get it from the notification object anymore
     
     - parameter notification: the notification object from the OS
     */
    func keyboardChangeAnimation(_ notification: Notification) {
        view.layoutIfNeeded()
    }

    /**
     Call this method to store the current "standard" values of a constraint in order to be able to just "restore to the initial values"
     
     Note, that this method only stores the constant values ONCE for each constraint. So you do not need to care about, whether you already called it for a given constraint.
     */
    func storeConstraintConstantForKeyboardAnimation(_ constr: NSLayoutConstraint, overwriteOriginal: Bool = false) {
        let identifier = NSString(format:"%p", constr) as String
        if keyboardLayoutChanges[identifier] != nil {
            if !overwriteOriginal {
                return
            }
        }
        keyboardLayoutChanges[identifier] = LayoutConstrainInfo(constraint: constr, constant: constr.constant)
    }

    /**
     Call this method to store the current contentInset of a scrollView in order to be able to just "restore to the initial value"
     
     Note, that if 'overwriteOriginal' is false (default) this method only stores the contentInset value ONCE for each scrollView.
     So you do not need to care about, whether you already called it for a given scrollView.
     
     - parameter constr:            NSLayoutContraint object to store the constant of
     - parameter overwriteOriginal: Boolean flag, whether or not to overwrite already existing value (default: false)
     */
    func storeContentInsetsForKeyboardAnimation(_ scrollView: UIScrollView, overwriteOriginal: Bool = false) {
        let identifier = String(format: "%p", scrollView) as String
        if storedOriginalContentInset[identifier] != nil {
            if !overwriteOriginal {
                return
            }
        }
        storedOriginalContentInset[identifier] = ContentInsetInfo(scrollView: scrollView, insets: scrollView.contentInset)
    }

    /**
     Call this method to reset the changes to the constraints, which stored their original constant values using storeConstraintConstantForKeyboardAnimation:NSLayoutConstraint
     
     Note, that this method gets automatically called when the keyboard hides!
     */
    func resetKeyboardLayoutChanges() {
        for (_, value) in keyboardLayoutChanges {
            value.constraint?.constant = value.constant
        }
        keyboardLayoutChanges = [String: LayoutConstrainInfo]()

        for (_, value) in storedOriginalContentInset {
            value.scrollView?.contentInset = value.insets
        }
        storedOriginalContentInset = [String: ContentInsetInfo]()
    }

    // MARK: - keyboard support calls

    /**
     Hide keyboard, if any
     */
    func hideKeyboard() {
        view.endEditing(true)
    }
}
