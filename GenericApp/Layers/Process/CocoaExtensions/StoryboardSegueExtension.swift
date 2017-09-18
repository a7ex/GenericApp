//
//  StoryboardSegueExtension.swift
//  MovingLab
//
//  Created by Alex da Franca on 29.05.17.
//  Copyright © 2017 apprime. All rights reserved.
//

import UIKit

extension UIStoryboardSegue {

    /**
     Always dereference the rootviewController from a UIStoryboardSegue

     In prepareForSegue for example we most of the times want the viewController with our custom subclass
     whether it is embedded in a navigationController or in a splitVCiewController or not embedded at all.
     With this method we do not need to care, whether the destinationViewController is embedded or not
     */
    func destinationTopController() -> UIViewController? {
        var muttableDestination: UIViewController? = destination
        if let navCon = destination as? UINavigationController {
            muttableDestination = navCon.visibleViewController
        } else if let splitCon = destination as? UISplitViewController {
            muttableDestination = splitCon.viewControllers.first
        }
        return muttableDestination
    }
}
