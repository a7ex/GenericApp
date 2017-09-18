//
//  UIView+Blur.swift
//  MovingLab
//
//  Created by Alex da Franca on 29.05.17.
//  Copyright © 2017 apprime. All rights reserved.
//

import UIKit

extension UIView {

    /// Get the nearest parent of a given type
    ///
    /// Go recursively through the parent views and return the first one,
    /// which matches the provided type
    ///
    /// E.g. in order to find the tableView which contains a certain cell:
    /// let enclosingTableView = tableCell.nearestSuperview(ofType: UITableView.self)
    ///
    /// - Parameter type: the type of the view, which we are looking for
    /// - Returns: The first superview, which matches the given type
    func nearestSuperview<T: UIView>(ofType type: T.Type) -> T? {
        return superview as? T ?? superview?.nearestSuperview(ofType: type)
    }

    func blur() {
        let blurView: UIView
        if #available(iOS 8, *) {
            let blurEffect = UIBlurEffect(style: .extraLight)
            blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = frame
        } else { // workaround for iOS 7
            blurView = UIToolbar(frame: bounds)
        }
        ffs_addSubview(blurView)

        //        // another method would be:
        //        import "UIImageEffects"
        //        ...
        //        yourImageView.image = UIImageEffects.imageByApplyingLightEffectToImage(imageInstance)
        // UIImageEffects is an extension for UIImage from the Apple Dev Library
    }

}
