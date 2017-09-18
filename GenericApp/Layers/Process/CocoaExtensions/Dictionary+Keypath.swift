//
//  Dictionary+Keypath.swift

import Foundation

extension Dictionary where Key == String {
    func value(forKeyPath keyPath: String) -> Any? {
        guard !keyPath.isEmpty else { return nil }
        let keys = keyPath.components(separatedBy: ".")
        guard let firstKey = keys.first,
            let val = self[firstKey] else { return nil }
        if keys.count > 1 {
            if let arr = val as? [Any],
                let index = Int(keys[1]),
                index > -1,
                index < arr.count {
                if keys.count > 2 {
                    let newKey = keys.suffix(from: 2).joined(separator: ".")
                    return (arr[index] as? [String: Any])?.value(forKeyPath: newKey)
                } else {
                    return arr[index]
                }
            } else if let dict = val as? [String: Any] {
                let newKey = keys.suffix(from: 1).joined(separator: ".")
                return dict.value(forKeyPath: newKey)
            } else {
                return nil
            }
        }
        return val
    }
}

extension Dictionary where Key == String, Value == Any {
    mutating func setValue(_ value: Any, forKeyPath keyPath: String) {
        guard !keyPath.isEmpty else { return }
        let keys = keyPath.components(separatedBy: ".")
        if keys.count > 1 {
            var subdict: [String: Any]
            //swiftlint:disable:next force_unwrapping
            if let val = self[keys.first!] as? [String: Any] {
                subdict = val
            } else {
                subdict = [String: Any]()
            }
            //swiftlint:disable:next force_unwrapping
            self[keys.first!] = subdict
            let newKey = keys.suffix(from: 1).joined(separator: ".")
            subdict.setValue(value, forKeyPath: newKey)
        } else {
            //swiftlint:disable:next force_unwrapping
            self[keys.first!] = value
        }
    }
}
