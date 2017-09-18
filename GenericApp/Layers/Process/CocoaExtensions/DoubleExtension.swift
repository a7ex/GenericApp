//
//  DoubleExtension.swift
//  MovingLab
//
//  Created by Alex Apprime on 18.06.17.
//  Copyright © 2017 apprime. All rights reserved.
//

import Foundation

extension Double {
    var dateValue: Date? {
        return Date(timeIntervalSince1970: (self / 1000.0))
    }
}
