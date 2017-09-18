//
//  IntegerExtension.swift
//  MovingLab
//
//  Created by Alex da Franca on 29.05.17.
//  Copyright © 2017 apprime. All rights reserved.
//

import Foundation

extension Int {
    func randomInt() -> Int {
        return Int(arc4random_uniform(UInt32(self)))
    }

    var dateValue: Date? {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
}
