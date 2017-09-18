//
//  EnumExtension.swift
//  MovingLab
//
//  Created by Alex da Franca on 29.05.17.
//  Copyright © 2017 apprime. All rights reserved.
//

import Foundation

/// One possible solution for an allValues method for enums
/// However the base type of the enum needs to be Hashable

protocol EnumCollection: Hashable {
    static var allValues: [Self] { get }
}

extension EnumCollection {

    static func cases() -> AnySequence<Self> {
        return AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            return AnyIterator {
                let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: Self.self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else { return nil }
                raw += 1
                return current
            }
        }
    }

    static var allValues: [Self] {
        return Array(self.cases())
    }
}
