//
//  ZoomNavigationAnimator.swift
//
//  Created by Alex da Franca on 07/01/16.
//  Copyright © 2016 Farbflash. All rights reserved.
//

import UIKit

//// // Add this extension to your ViewController subclass
//extension YourViewController: UIViewControllerTransitioningDelegate, CustomNavigationTransitiong {
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return zoomTransitionAnimator
//    }
//
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        zoomTransitionAnimator?.presenting = false
//        return zoomTransitionAnimator
//    }
//}

protocol CustomNavigationTransitiong: class {
    var zoomTransitionAnimator: ZoomNavigationAnimator? { get set }
}

class ZoomNavigationAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var duration = 0.6
    var presenting = true
    var originFrame = CGRect.zero
    var fadeDuringTransition = true

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView

        // swiftlint:disable force_unwrapping
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let presentedView = presenting ? toView : transitionContext.view(forKey: UITransitionContextViewKey.from)!
        // swiftlint:enable force_unwrapping

        // containerView.frame has the frame according to the devioce rotation
        // if the the both viewcontrollers have different rotation restrictions
        // than toView will still have the frame from the fromViewController, which might be rotation restricted
        // and vice versa. So we adjust the frame here
        toView.frame = containerView.frame

        let initialFrame = presenting ? originFrame : presentedView.frame
        let finalFrame = presenting ? presentedView.frame : originFrame

        let xScaleFactor = presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
        let yScaleFactor = presenting ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)

        if presenting {
            presentedView.transform = scaleTransform
            presentedView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            presentedView.clipsToBounds = true
            if fadeDuringTransition {
                presentedView.alpha = 0
            }
        }

        containerView.addSubview(toView)
        containerView.bringSubview(toFront: presentedView)

        UIView.animate(withDuration: duration, delay:0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: {
                        presentedView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
                        presentedView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
                        if self.fadeDuringTransition {
                            presentedView.alpha = self.presenting ? 1: 0
                        }
        },
                       completion: { _ in
                        transitionContext.completeTransition(true)
        })
    }
}
