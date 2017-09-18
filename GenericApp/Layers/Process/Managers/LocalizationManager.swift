//
//  LocalizationManager.swift
//  MovingLab
//
//  Created by Alex da Franca on 29.05.17.
//  Copyright © 2017 apprime. All rights reserved.
//

import Foundation

/**
 Replacement for NSLocalizedString
 
 If we want to change languages at runtime so we can not use NSLocalizedString, which requires static strings
 rather we run our own translation system
 
 - parameter key: localizable key
 - returns: String with translated string
 */
func LocalizedString(_ key: String, comment: String) -> String {
    return LocalizationManager.sharedInstance.localizedString(forKey: key)
}

/**
 Get path to localized file resource
 For the case, where we need to roll our own localization calls, as the localization doesn't
 obey the system settings for the localization language
 
 - parameter filename: the name of the file
 - parameter fileExtension: the extension of the file
 - returns: filepath
 */
func localizedPathForResource(_ filename: String, ofType fileExtension: String) -> String? {
    return LocalizationManager.sharedInstance.localizedPathForResourceWithName(filename, ofType: fileExtension)
}

final class LocalizationManager {

    static let sharedInstance = LocalizationManager()
    private final var currentBundle = Bundle.main
    private final var currentI18NData: [String: String]?

    private init() {
        let regionID = "\(ConfigValues.LanguageIdentifier())-\(ConfigValues.RegionIdentifier())"
        setLanguage(regionID)
    }

    /**
     Set the current active language for translations
     
     Set the instance variable currentBundle to the bundle
     corresponding to the specified locale (if any)
     
     - parameter lang: String locale (accepts laguage only (e.g. "de") as well as language and region (e.g. "de-AT"))
     */
    final func setLanguage(_ lang: String) {
        var path = Bundle.main.path(forResource: lang, ofType: "lproj")
        if path == nil {
            let onlylang = lang.components(separatedBy: "-").first ?? ""
            path = Bundle.main.path(forResource: onlylang, ofType: "lproj")
        }
        if let path = path {
            if let newBundle = Bundle(path: path) {
                currentBundle = newBundle
                return
            }
        }
        // fallback
        currentBundle = Bundle.main
    }

    fileprivate final func localizedString(forKey key: String) -> String {
        return currentBundle.localizedString(forKey: key, value: key, table: nil)
    }

    fileprivate final func localizedPathForResourceWithName(_ filename: String, ofType fileExtension: String) -> String? {
        if let retval = currentBundle.path(forResource: filename, ofType: fileExtension).nonEmptyString {
            return retval
        }
        return Bundle.main.path(forResource: filename, ofType: fileExtension)
    }
}
