//
//  UIView+AutoLayout.swift
//  MovingLab
//
//  Created by Alex da Franca on 29.05.17.
//  Copyright © 2017 apprime. All rights reserved.
//

import UIKit

extension UIView {

    /**
     Get an array ith all constraints attached to the receiver view

     The constraints property of a view only contains the width and height cosntraints (-> descendant constraints)
     But sometimes we need to query all constraints which are applied to a view

     - returns: array with layout constraints attached to the view
     */
    func ffs_constraintsAttached() -> [NSLayoutConstraint] {
        var constrs = [NSLayoutConstraint]()

        constrs += ffs_userAddedConstraints(constraints)

        // swiftlint:disable force_unwrapping
        var parentView: UIView? = superview
        while parentView != nil {
            for thisConstraint in ffs_userAddedConstraints(parentView!.constraints) {
                if thisConstraint.firstItem as? UIView == self || thisConstraint.secondItem as? UIView == self {
                    constrs.append(thisConstraint)
                }
            }
            parentView = parentView?.superview
        }
        // swiftlint:enable force_unwrapping
        return constrs
    }

    // in ost cases we want to skip automatically added constraints, like: NSContentSizeLayoutConstraint etc.
    func ffs_userAddedConstraints(_ constraintList: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        //        return constraintList.filter({$0.dynamicType === NSLayoutConstraint.self}) // doesn't compile, why ever?!
        var constrs = [NSLayoutConstraint]()
        for thisConstraint in constraintList where type(of: thisConstraint) === NSLayoutConstraint.self {
            constrs.append(thisConstraint)
        }
        return constrs
    }

    /**
     Get a layout constraint from the receiver view by attribute

     - parameter layoutAttribute: the NSLayoutAttribute, which defines the constraint

     - returns: The layout constraint with the specified attribute or nil, if not present
     */
    func ffs_layoutConstraintWithAttribute(_ layoutAttribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        if layoutAttribute == .height || layoutAttribute == .width {
            let constrs = ffs_userAddedConstraints(constraints).filter {($0.firstItem as? UIView == self && $0.firstAttribute == layoutAttribute)}
            if let constr = constrs.first {
                return constr
            }
        }

        var parentView: UIView? = superview
        while parentView != nil {
            // swiftlint:disable:next force_unwrapping
            for thisConstraint in ffs_userAddedConstraints(parentView!.constraints) {
                if thisConstraint.firstItem as? UIView == self && thisConstraint.firstAttribute as NSLayoutAttribute == layoutAttribute {
                    return thisConstraint
                }
                if thisConstraint.secondItem as? UIView == self && thisConstraint.secondAttribute as NSLayoutAttribute == layoutAttribute {
                    return thisConstraint
                }
            }
            parentView = parentView?.superview
        }

        return nil
    }

    /**
     Uninstall a layout attribute specified by attribute

     - parameter layoutAttribute: NSLayoutAttribute which defines the constraint to remove from the receiver view
     */
    func ffs_removeLayoutConstraintWithAttribute(_ layoutAttribute: NSLayoutAttribute) {
        if layoutAttribute == .height || layoutAttribute == .width {
            let constrs = ffs_userAddedConstraints(constraints).filter {($0.firstItem as? UIView == self && $0.firstAttribute == layoutAttribute)}
            for thisConstraint in constrs {
                removeConstraint(thisConstraint)
            }
        }

        var parentView: UIView? = superview
        while parentView != nil {
            // swiftlint:disable force_unwrapping
            for thisConstraint in ffs_userAddedConstraints(parentView!.constraints) {
                if thisConstraint.firstItem as? UIView == self && thisConstraint.firstAttribute as NSLayoutAttribute == layoutAttribute {
                    parentView!.removeConstraint(thisConstraint)
                    return
                }
                if thisConstraint.secondItem as? UIView == self && thisConstraint.secondAttribute as NSLayoutAttribute == layoutAttribute {
                    parentView!.removeConstraint(thisConstraint)
                    return
                }
            }
            // swiftlint:enable force_unwrapping
            parentView = parentView?.superview
        }
    }

    /**
     Get the distances to all four sides of the parent view as UIEdgeInsets

     - returns: spacing to the parentview as UIEdgeInsets
     */
    func ffs_edgeInsetsToParentView() -> UIEdgeInsets {

        guard let superview = superview else { return UIEdgeInsets.zero }

        let left = frame.origin.x
        let top = frame.origin.y
        let right = superview.frame.size.width - left - frame.size.width
        let bottom = superview.frame.size.height - top - frame.size.height

        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }

    /**
     Get the distances to all four sides of the provided view as UIEdgeInsets

     - returns: spacing to the arbitrary view as UIEdgeInsets
     */
    func ffs_edgeInsetsToView(_ referenceView: UIView) -> UIEdgeInsets {

        guard let superview = superview else { return UIEdgeInsets.zero }

        let translatedRect = superview.convert(frame, to:referenceView)
        let left = translatedRect.origin.x
        let top = translatedRect.origin.y
        let right = referenceView.frame.size.width - left - translatedRect.size.width
        let bottom = referenceView.frame.size.height - top - translatedRect.size.height

        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }

    /**
     Convert the constraints applied to a view to UIEdgeInsets

     Take the constant values of leading, trailing, top and bottom constraints added to the layoutmargins defined to the view
     (TODO: This is probably wrong, layoutMargins should probably only be added, if the constraint in question was installed to the margin rather than to the edge of the view)

     - returns: UIEdgeInsets
     */
    func ffs_constraintsToInsets() -> UIEdgeInsets {
        var leftConst = CGFloat(0), rightConst = CGFloat(0), topConst = CGFloat(0), bottomConst = CGFloat(0)

        if let constr = ffs_layoutConstraintWithAttribute(.leading) {
            leftConst = constr.constant + layoutMargins.left
        }
        if let constr = ffs_layoutConstraintWithAttribute(.trailing) {
            rightConst = constr.constant + layoutMargins.right
        }
        if let constr = ffs_layoutConstraintWithAttribute(.top) {
            topConst = constr.constant + layoutMargins.top
        }
        if let constr = ffs_layoutConstraintWithAttribute(.bottom) {
            bottomConst = constr.constant + layoutMargins.bottom
        }
        return UIEdgeInsets(top: topConst, left: leftConst, bottom: bottomConst, right: rightConst)
    }

    /**
     Add a subview AND position it within the parent view according to the supplied UIEdgeInsets using AutoLayout

     - parameter subViewToAdd: UIView, which shall be added as subview
     - parameter edgeInsets:   UIEdgeInsets, which define the position to the superview
     */
    func ffs_addSubview(_ subViewToAdd: UIView, withEdgeInsets edgeInsets: UIEdgeInsets = .zero) {

        addSubview(subViewToAdd)

        let metrics = ["left": edgeInsets.left, "top": edgeInsets.top, "right": edgeInsets.right, "bottom": edgeInsets.bottom]
        let views = ["subViewToAdd": subViewToAdd]

        subViewToAdd.translatesAutoresizingMaskIntoConstraints = false

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(left)-[subViewToAdd]-(right)-|",
                                                           options:NSLayoutFormatOptions(),
                                                           metrics:metrics,
                                                           views:views))

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[subViewToAdd]-(bottom)-|",
                                                           options:NSLayoutFormatOptions(),
                                                           metrics:metrics,
                                                           views:views))
    }

    /**
     Hide a view by setting the height constraint to 0 and the bottom constraint constant to 0 as well

     This only works, IF the view has a height constraint
     */
    func ffs_hideViewBySettingHeightConstraintToZero() {
        if let heightConstraint = ffs_layoutConstraintWithAttribute(.height) {
            heightConstraint.constant = 0.0
            if let bottomConstraint = ffs_layoutConstraintWithAttribute(.bottom) {
                bottomConstraint.constant = 0.0
            }
        }
    }

    /**
     Hide a view by setting the width constraint to 0 and the trailing constraint constant to 0 as well

     This only works, IF the view has a width constraint
     */
    func ffs_hideViewBySettingWidthConstraintToZero() {
        if let widthConstraint = ffs_layoutConstraintWithAttribute(.width) {
            widthConstraint.constant = 0.0
            if let trailingConstraint = ffs_layoutConstraintWithAttribute(.trailing) {
                trailingConstraint.constant = 0.0
            }
        } else { //if we use only intrinsicContentSize we dont have width constant, we must add it with 0 value
            let widthConstraint = NSLayoutConstraint(
                item: self,
                attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal,
                toItem: nil,
                attribute: NSLayoutAttribute.notAnAttribute,
                multiplier: 1,
                constant: 0
            )
            addConstraint(widthConstraint)
        }
    }

    /**
     Hide a view by setting either the width - or the height constraint to 0 and the bottom - or trailing constraint constant to 0 as well

     This only works, IF the view has one of both width - or height constraint
     */
    func ffs_hideViewBySettingConstraintToZero() {
        if ffs_layoutConstraintWithAttribute(.height) != nil {
            ffs_hideViewBySettingHeightConstraintToZero()
        } else {
            ffs_hideViewBySettingWidthConstraintToZero()
        }
    }

}
