//
//  StoreConstraintsExtension.swift

import UIKit

// MARK: - Store and restore constraint constant values

extension BaseVC {

    /**
     Call this method to store the current constant of a constraint in order to be able to just "restore to the initial value"
     
     Note, that if 'overwriteOriginal' is false (default) this method only stores the constant value ONCE for each constraint.
     So you do not need to care about, whether you already called it for a given constraint.
     
     - parameter constr:            NSLayoutContraint object to store the constant of
     - parameter overwriteOriginal: Boolean flag, whether or not to overwrite already existing value (default: false)
     */
    func storeOriginalConstantOfLayoutConstraint(_ constr: NSLayoutConstraint, overwriteOriginal: Bool = false) {
        let identifier = String(format: "%p", arguments: [constr])
        if storedOriginalConstraints[identifier] != nil {
            if !overwriteOriginal {
                return
            }
        }
        storedOriginalConstraints[identifier] = LayoutConstrainInfo(constraint: constr, constant: constr.constant)
    }

    /**
     Call this method to reset the changes to the constraint, which stored their original constant values using storeOriginalConstantOfLayoutConstraint:NSLayoutConstraint:Bool
     
     - parameter constr: NSLayoutContraint object which shall be set to original value
     */
    func restoreOriginalConstantOfLayoutConstraint(_ constr: NSLayoutConstraint) {
        let identifier = String(format: "%p", arguments: [constr])
        if let storedConstraintInfo = storedOriginalConstraints[identifier] {
            storedConstraintInfo.constraint?.constant = storedConstraintInfo.constant
        }
    }

    /**
     Call this method to hide a view by setting its width constraint AND its trailing constraint to 0
     
     - parameter viewToHide:            any UIView or its subclass, which has a width constraint installed
     */
    func hideViewBySettingWidthToZero(_ viewToHide: UIView) {
        guard let widthConstraint = viewToHide.ffs_layoutConstraintWithAttribute(.width) else {
//            fatalError("hideViewBySettingWidthToZero called but no width constraint was found on view")
            print("\n\nFATAL:\nhideViewBySettingWidthToZero called but no width constraint was found on view\n")
            return
        }
        storeOriginalConstantOfLayoutConstraint(widthConstraint)
        viewToHide.clipsToBounds = true
        widthConstraint.constant = 0
        guard let trailingConstraint = viewToHide.ffs_layoutConstraintWithAttribute(.trailing) else {
            return
        }
        storeOriginalConstantOfLayoutConstraint(widthConstraint)
        trailingConstraint.constant = 0.0
    }

    /**
     Call this method unhide a view, which was prior hidden using the above 'hideViewBySettingWidthToZero' function
     
     - parameter viewToShow:            any UIView, which was previously hidden by hideViewBySettingWidthToZero
     */
    func showViewByRestoringWidth(_ viewToShow: UIView) {
        if let widthConstraint = viewToShow.ffs_layoutConstraintWithAttribute(.width) {
            restoreOriginalConstantOfLayoutConstraint(widthConstraint)
        }
        if let trailingConstraint = viewToShow.ffs_layoutConstraintWithAttribute(.trailing) {
            restoreOriginalConstantOfLayoutConstraint(trailingConstraint)
        }
    }

    /**
     Call this method to hide a view by setting its height constraint AND its bottom constraint to 0
     
     - parameter viewToHide:            any UIView or its subclass, which has a height constraint installed
     */
    func hideViewBySettingHeightToZero(_ viewToHide: UIView) {
        guard let heightConstraint = viewToHide.ffs_layoutConstraintWithAttribute(.height) else {
//            fatalError("hideViewBySettingHeightToZero called but no height constraint was found on view")
            print("\n\nFATAL:\nhideViewBySettingHeightToZero called but no height constraint was found on view\n")
            return
        }
        storeOriginalConstantOfLayoutConstraint(heightConstraint)
        viewToHide.clipsToBounds = true
        heightConstraint.constant = 0
        guard let bottomConstraint = viewToHide.ffs_layoutConstraintWithAttribute(.bottom) else {
            return
        }
        storeOriginalConstantOfLayoutConstraint(bottomConstraint)
        bottomConstraint.constant = 0.0
    }

    /**
     Call this method unhide a view, which was prior hidden using the above 'hideViewBySettingHeightToZero' function
     
     - parameter viewToShow:            any UIView, which was previously hidden by hideViewBySettingHeightToZero
     */
    func showViewByRestoringHeight(_ viewToShow: UIView) {
        if let heightConstraint = viewToShow.ffs_layoutConstraintWithAttribute(.height) {
            restoreOriginalConstantOfLayoutConstraint(heightConstraint)
        }
        if let bottomConstraint = viewToShow.ffs_layoutConstraintWithAttribute(.bottom) {
            restoreOriginalConstantOfLayoutConstraint(bottomConstraint)
        }
    }

}
