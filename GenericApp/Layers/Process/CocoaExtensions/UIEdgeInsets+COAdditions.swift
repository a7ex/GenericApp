//
//  UIEdgeInsets+COAdditions.swift
//  conradkiosk
//
//  Created by Alex da Franca on 02/12/2016.
//  Copyright © 2016 Conrad Electronics SE. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    /// use the contentInsets of a scrollView to set the contentOffset
    var asContentOffset: CGPoint {
        return CGPoint(x: left * -1, y: top * -1)
    }
}
