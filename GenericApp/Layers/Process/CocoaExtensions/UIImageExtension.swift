//
//  UIImageExtension.swift
//  MovingLab
//
//  Created by Alex da Franca on 29.05.17.
//  Copyright © 2017 apprime. All rights reserved.
//

import UIKit

extension UIImage {

    /**
     Computed property: Returns half sized version of receiver image
     */
    var halfsized: UIImage? {

        let halfWidth = self.size.width / 2
        let halfHeight = self.size.height / 2

        UIGraphicsBeginImageContext(CGSize(width: halfWidth, height: halfHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: halfWidth, height: halfHeight))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return img
    }

    /**
     Crop image to rect
     */
    func crop(toRect rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, self.scale)
        self.draw(at: CGPoint(x: -rect.origin.x, y:-rect.origin.y))
        let cropped_image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return cropped_image
    }

    /**
     Combine images in array to single image
     */
    class func combine(images: UIImage..., scale: CGFloat) -> UIImage {
        var contextSize = CGSize.zero

        for image in images {
            contextSize.width += image.size.width
            contextSize.height = max(contextSize.height, image.size.height)
        }

        UIGraphicsBeginImageContextWithOptions(contextSize, false, scale)

        for (index, image) in images.enumerated() {
            let originX = image.size.width * CGFloat(index)
            image.draw(in: CGRect(x: originX, y: 0.0, width: image.size.width, height: image.size.height))
        }

        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        // swiftlint:disable force_unwrapping
        return combinedImage!
    }
}
