//
//  URLExtension.swift

import Foundation

extension URL {
    /// Get the url parameters as Dictionary
    var urlParamDictionary: [String: [String]] {
        var urlParamDictionary = [String: [String]]()
        if let paramPairs = query?.components(separatedBy: "&"),
            paramPairs.count > 0 {
            for paramPair in paramPairs {
                let parts = paramPair.components(separatedBy: "=")
                if parts.count < 2 { continue }
                guard let key = parts[0].removingPercentEncoding,
                    let value = parts[1].removingPercentEncoding else {
                        continue
                }
                var oldValues = urlParamDictionary[key] ?? [String]()
                oldValues.append(value)
                urlParamDictionary[key] = oldValues
            }
        }
        return urlParamDictionary
    }
}
