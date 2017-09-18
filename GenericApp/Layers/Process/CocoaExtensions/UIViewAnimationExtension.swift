//
//  UIViewAnimationExtension.swift
//  MovingLab
//
//  Created by Alex da Franca on 29.05.17.
//  Copyright © 2017 apprime. All rights reserved.
//

import UIKit

extension UIView {
    func fadeTo(_ alpha: CGFloat, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .beginFromCurrentState, animations: {
                self.alpha = alpha
            }, completion: nil)
        } else {
            self.alpha = alpha
        }
    }
}
