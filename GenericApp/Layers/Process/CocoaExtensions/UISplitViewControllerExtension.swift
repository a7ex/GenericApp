//
//  UISplitViewControllerExtension.swift
//  MovingLab
//
//  Created by Alex da Franca on 26.07.17.
//  Copyright © 2017 apprime. All rights reserved.
//

import UIKit

extension UISplitViewController {
    /**
     Convenience method to get the detail view controller as UINavigationController

     - returns: Either a UINavigationController instance or nil
     */
    func getDetailNavigationController() -> UINavigationController? {
        if let navContr = viewControllers.last as? UINavigationController {
            return navContr
        }
        return nil
    }

    /**
     Convenience method to get the detail view controller

     - returns: Either the visibleViewController of an UINavigationController if present or an UIViewController
     */
    func getDetailTopController() -> UIViewController? {
        if let navContr = viewControllers.last as? UINavigationController {
            return navContr.visibleViewController
        }
        return viewControllers.last
    }

    /**
     Convenience method to get the master view controller as UINavigationController

     - returns: Either a UINavigationController instance or nil
     */
    func getMasterNavigationController() -> UINavigationController? {
        if let navContr = viewControllers.first as? UINavigationController {
            return navContr
        }
        return nil
    }

    /**
     Convenience method to get the master view controller

     - returns: Either the visibleViewController of an UINavigationController if present or an UIViewController
     */
    func getMasterTopController() -> UIViewController? {
        if let navContr = viewControllers.first as? UINavigationController {
            return navContr.visibleViewController
        }
        return viewControllers.first
    }

    /**
     Adjust the width of the two splitview panes by defining the ratio

     - parameter ratio: a float between 0.0 and 1.0, which defines the ratio between master and detail split
     */
    func setWidthOfSplitViewsToRatio(_ ratio: CGFloat) {
        self.preferredPrimaryColumnWidthFraction = ratio
        self.maximumPrimaryColumnWidth = self.view.bounds.size.width
    }

}
