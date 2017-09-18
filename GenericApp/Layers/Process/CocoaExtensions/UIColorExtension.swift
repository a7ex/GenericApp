//
//  UIColorExtension.swift
//  MovingLab
//
//  Created by Alex da Franca on 29.05.17.
//  Copyright © 2017 apprime. All rights reserved.
//

import UIKit

extension UIColor {

    /**
     Convert initializer for UIColor which takes a hex string

     Creates an UIColor object according to the supplied hex string
     If the receiver string can't be converted into a color, white color is returned
     The string can contain information for the alpha channel as well, at position 7 and 8
     The string can either begin with # or with 0x or without any prefix
     The string can be 3 (rgb), 4 (rgba), 6 (rrggbb) or 8 (rrggbbaa) characters
     In case of 3 or 4 characters, the characters are duplicated: F0A -> FF00AA, F0A9 -> FF00AA99

     - returns: returns an UIColor object
     */
    convenience init(hex: String) {

        // trim and make lowercase
        var hexString = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        hexString = hexString.lowercased()

        // remove leading #
        if hexString.hasPrefix("#") {
            hexString = String(hexString[hexString.characters.index(hexString.startIndex, offsetBy: 1)...])
        }

        // remove leading 0x
        if hexString.hasPrefix("0x") {
            hexString = String(hexString[hexString.characters.index(hexString.startIndex, offsetBy: 2)...])
        }

        if hexString.characters.count == 3 {
            hexString += "f"
        }

        if hexString.characters.count == 4 {
            let r = String(hexString[hexString.characters.index(hexString.startIndex, offsetBy: 0)])
            let g = String(hexString[hexString.characters.index(hexString.startIndex, offsetBy: 1)])
            let b = String(hexString[hexString.characters.index(hexString.startIndex, offsetBy: 2)])
            let a = String(hexString[hexString.characters.index(hexString.startIndex, offsetBy: 3)])

            hexString = "\(r)\(r)\(g)\(g)\(b)\(b)\(a)\(a)"
        }

        if hexString.characters.count == 6 {
            hexString += "ff"
        }

        var red = CGFloat(1.0)
        var green = CGFloat(1.0)
        var blue = CGFloat(1.0)
        var alpha = CGFloat(1.0)

        if hexString.characters.count == 8 {

            var value: UInt32 = 0
            Scanner(string: hexString).scanHexInt32(&value)

            red = CGFloat((value & 0xFF000000) >> 24) / 255.0
            green = CGFloat((value & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((value & 0x0000FF00) >> 8) / 255.0
            alpha = CGFloat((value & 0x000000FF)) / 255.0

        }

        self.init(red:red, green:green, blue:blue, alpha:alpha )
    }

    /**
     Make a color slightly brigther by multiplying the brightness by factor 1.3

     - returns: brighter UIColor object, than the receiver
     */
    func co_lighten() -> UIColor {
        return co_multiplyBrightnessBy(1.3)
    }

    /**
     Make a color slightly darker by multiplying the brightness by factor 0.75

     - returns: darker UIColor object, than the receiver
     */
    func co_darken() -> UIColor {
        return co_multiplyBrightnessBy(0.75)
    }

    /**
     Make a color darker or brighter by multiplying the brightness by a provided factor

     Values greater than 1 make the receiver color brighter
     Values smaller than 1 make the receiver color darker

     - parameter factor: a factor as CGFloat value

     - returns: darker UIColor object, than the receiver
     */
    func co_multiplyBrightnessBy(_ factor: CGFloat) -> UIColor {
        var hue = CGFloat(0)
        var saturation = CGFloat(0)
        var brightness = CGFloat(0)
        var alpha = CGFloat(0)
        var white = CGFloat(0)

        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: min(brightness, (brightness * factor)), alpha: alpha)
        } else if getWhite(&white, alpha:&alpha) {
            return UIColor(white: (white * factor), alpha:alpha)
        }
        return self
    }

    /**
     * Returns a color with adjusted saturation and brigtness than can be used to
     * indicate control is disabled.
     */
    func disabledColor() -> UIColor {
        var h = CGFloat(0)
        var s = CGFloat(0)
        var b = CGFloat(0)
        var a = CGFloat(0)

        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s * 0.5, brightness: b * 1.2, alpha: a)
    }

    func darkerColor(_ percentage: CGFloat) -> UIColor {
        var h = CGFloat(0)
        var s = CGFloat(0)
        var b = CGFloat(0)
        var a = CGFloat(0)

        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s * (1 + percentage), brightness: b * (1 - percentage), alpha: a)
    }
}
