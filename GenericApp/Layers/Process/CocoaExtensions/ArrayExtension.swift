//
//  ArrayExtension.swift
//  MovingLab
//
//  Created by Alex da Franca on 29.05.17.
//  Copyright © 2017 apprime. All rights reserved.
//

import Foundation

extension Array {
    /**
     Access elements of array without index out of range error

     This method checks, whether the specified index in the array is within the bounds of the array
     and if NOT returns a default value, which can also be specified optionally

     Example:
     print(myArray.item(at: -2, "Not found"))
     -- "Not found"

     - parameter index:        Integer zero-based index of element in array
     - parameter defaultValue: optional default value to return in case of out of bounds index (default = nil)

     - returns: element of array at index position OR defaultValue (nil)
     */
    func item(at index: Int, defaultValue: Element?=nil) -> Element? {
        return (index >= 0 && index < count) ? self[index] : defaultValue
    }

    func randomItem() -> Element? {
        guard !self.isEmpty else { return nil }
        let pos = Int(arc4random_uniform(UInt32(self.count)))
        return self[pos]
    }

    func pickRandomly(_ numberOfItems: UInt) -> [Element] {
        var newArray = [Element]()
        guard self.count >= Int(numberOfItems) else { return newArray }
        var copy = self
        for _ in 0..<numberOfItems {
            let pos = Int(arc4random_uniform(UInt32(copy.count)))
            newArray.append(copy[pos])
            copy.remove(at: pos)
        }
        return newArray
    }
}
