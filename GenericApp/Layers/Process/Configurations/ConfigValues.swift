//
//  ConfigValues.swift

import UIKit

extension Notification.Name {
    static let login = Notification.Name("de.epd.successfulLoginEvent")
    static let logout = Notification.Name("de.epd.LogoutEvent")
}

final class ConfigValues {

    /// Get the singleton for this class
    /// returns: Singleton instance of ConfigValues class
    static let sharedInstance = ConfigValues()

    private lazy var configuration: [String: Any] = loadConfiguration()
    private lazy var storedColors = [String: Any]()
    private lazy var storedFonts = [String: Any]()

    // MARK: - Arbitrary keys

    /**
     Get arbitrary value for settings key

     - parameter key: String

     - returns: Returns the associated object or nil
     */
    final func configValueForKeyPath(_ keyPath: String) -> Any? {
        return configuration.value(forKeyPath: keyPath)
    }

    private final func setValue(_ val: Any, for keyPath: String, dict: inout [String: Any]) {
        guard !keyPath.isEmpty else { return }
        let keys = keyPath.components(separatedBy: ".")
        // swiftlint:disable force_unwrapping
        if keys.count > 1 {
            if var subDict = dict[keys.first!] as? [String: Any] {
                let newKey = keys.suffix(from: 1).joined(separator: ".")
                setValue(val, for: newKey, dict: &subDict)
            }
        } else {
            dict[keys.first!] = val
        }
        // swiftlint:enable force_unwrapping
    }

    /**
     Set arbitrary value for settings key

     Note, that this is runtime only! The newly appended key will only be available for this session.
     It will NOT get saved in the configuration.plist, where the initial values come from.

     - parameter value: This can be any object to be associated to a specific key
     - parameter key:   A unique key to store the value. Note, if the key exists, it will overwrite whatever was stored before for that key
     */
    final func setConfigValue(_ value: Any, forKeyPath keyPath: String) {
        setValue(value, for: keyPath, dict: &configuration)
    }

    // MARK: - Private

    final class func loadConfiguration() -> [String: Any] {
        if let configFileName = Bundle.main.object(forInfoDictionaryKey: "ConfigFileName") as? String {
            if let config = ConfigValues.loadConfigurationWithName(configFileName) {
                return config
            }
        }
        return [String: Any]()
    }

    final class func loadConfigurationWithName(_ configName: String) -> [String: Any]? {
        guard !configName.isEmpty else { return nil }
        guard let configFilePath = Bundle.main.path(forResource: configName, ofType: "plist"),
        var config = loadPList(from: URL(fileURLWithPath: configFilePath)) as? [String: Any] else {
                return nil
        }
        for subConfigName in config.keys {
            if let subConfigFileName = config[subConfigName] as? String,
                let subConf = loadConfigurationWithName(subConfigFileName) {
                config[subConfigName] = subConf
            }
        }
        return config
    }

    final private func loadConfiguration() -> [String: Any] {
        return ConfigValues.loadConfiguration()
    }

    final private func loadConfigurationWithName(_ configName: String) -> [String: Any]? {
        return ConfigValues.loadConfigurationWithName(configName)
    }

    final class func standardHTTPHeaderParameters() -> [String: String] {
        return [String: String]()
    }

    final class func LanguageIdentifier() -> String {
        return Locale.current.identifier.components(separatedBy: "_").first ?? "en"
    }

    final class func RegionIdentifier() -> String {
        return Locale.current.identifier.components(separatedBy: "_").last ?? "US"
    }

    private final class func loadPList(from fileUrl: URL) -> Any? {
        if let data = try? Data(contentsOf: fileUrl),
            let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) {
                return result
        }
        return nil
    }

    fileprivate final func colorWithIdentifier(_ colorIdentifier: String) -> UIColor {
        if let hexColor = storedColors[colorIdentifier] as? UIColor {
            return hexColor
        }
        if let colors = configuration.value(forKeyPath: "UIConfigValues.colors") as? [String: Any],
            let ident = colors[colorIdentifier] as? String {
            return UIColor(hex: ident)
        }
        return UIColor.black
    }

    fileprivate final func fontWithIdentifier(_ fontIdentifier: String) -> UIFont {
        if let fnt = fontWithIdentifierEventually(fontIdentifier) {
            return fnt
        }
        return UIFont.systemFont(ofSize: 14.0)
    }

    fileprivate final func fontWithIdentifierEventually(_ fontIdentifier: String) -> UIFont? {
        if let fnt = storedFonts[fontIdentifier] as? UIFont {
            return fnt
        }
        if let fonts = configuration.value(forKeyPath: "UIConfigValues.fonts") as? [String: Any],
            let fntInfo = fonts[fontIdentifier] as? [String: Any],
            let key1 = fntInfo["name"] as? String,
            let key2 = fntInfo["size"] as? CGFloat {
            switch key1 {
            case "System":
                let returnValue = UIFont.systemFont(ofSize: key2)
                setValue(returnValue, for: fontIdentifier, dict: &storedFonts)
                return returnValue
            case "SystemBold":
                let returnValue = UIFont.boldSystemFont(ofSize: key2)
                setValue(returnValue, for: fontIdentifier, dict: &storedFonts)
                return returnValue
            default:
                if let returnValue = UIFont(name: key1, size: key2) {
                    setValue(returnValue, for: fontIdentifier, dict: &storedFonts)
                    return returnValue
                }
            }
        }
        return nil
    }

    struct Colors {
        /**
         Convenience method to get the primary color

         - returns: Primary color as UIColor object
         */
        static var primary: UIColor {
            return ConfigValues.sharedInstance.colorWithIdentifier("primaryColor")
        }

        /**
         Convenience method to get the secondary color

         - returns: Secondary color as UIColor object
         */
        static var secondary: UIColor {
            return ConfigValues.sharedInstance.colorWithIdentifier("secondaryColor")
        }

        /**
         Convenience method to get the tertiary color

         - returns: Tertiary color as UIColor object
         */
        static var tertiaryLight: UIColor {
            return ConfigValues.sharedInstance.colorWithIdentifier("tertiaryColorLight")
        }

        /**
         Convenience method to get the tertiary dark color

         - returns: Tertiary dark color as UIColor object
         */
        static var tertiaryDark: UIColor {
            return ConfigValues.sharedInstance.colorWithIdentifier("tertiaryColorDark")
        }

        /**
         Convenience method to get the standard (regular) textcolor

         - returns: Standard textcolor as UIColor object
         */
        static var text: UIColor {
            return ConfigValues.sharedInstance.colorWithIdentifier("darkTextColor")
        }

        /**
         Convenience method to get a light textcolor for dark background

         - returns: Light textcolor as UIColor object
         */
        static var lightText: UIColor {
            return ConfigValues.sharedInstance.colorWithIdentifier("lightTextColor")
        }

        /**
         Convenience method to get the dark tint color for light backgrounds

         - returns: Dark tintcolor as UIColor object
         */
        static var darkTint: UIColor {
            return ConfigValues.Colors.primary
        }

        /**
         Convenience method to get the light tint color for dark backgrounds

         - returns: Light tintcolor as UIColor object
         */
        static var lightTint: UIColor {
            return ConfigValues.sharedInstance.colorWithIdentifier("lightTintColor")
        }

        /**
         Convenience method to get the color for disabled items

         - returns: Disabled color as UIColor object
         */
        static var disabled: UIColor {
            return ConfigValues.sharedInstance.colorWithIdentifier("disabledColor")
        }

        /**
         Convenience method to get the color for confirmation (constructive/positive)

         - returns: Confirmation color as UIColor object
         */
        static var confirm: UIColor {
            return ConfigValues.sharedInstance.colorWithIdentifier("confirmColor")
        }

        /**
         Convenience method to get the color for information

         - returns: Information color as UIColor object
         */
        static var info: UIColor {
            return ConfigValues.sharedInstance.colorWithIdentifier("infoColor")
        }

        /**
         Convenience method to get the background color for gray buttons

         - returns: Dark tintcolor as UIColor object
         */
        static var grayButtonBG: UIColor {
            return ConfigValues.Colors.lightText
        }

        /**
         Method to get any of the defined colors by identifier

         Note, that if the identifier string is unknown black is returned as a default fallback

         - returns: Associated color as UIColor object or black color in case the identifier doesnt exist
         */
        static func byID(_ colorIdentifier: String) -> UIColor {
            return ConfigValues.sharedInstance.colorWithIdentifier(colorIdentifier)
        }
    }

    struct Fonts {
        /**
         Convenience method to get the font for the body style

         - returns: Body font as UIFont object
         */
        static var body: UIFont {
            return ConfigValues.sharedInstance.fontWithIdentifier("body")
        }

        /**
         Convenience method to get the font for the headline style

         - returns: Headline font as UIFont object
         */
        static var headline: UIFont {
            return ConfigValues.sharedInstance.fontWithIdentifier("headline")
        }

        /**
         Convenience method to get the font for the subhead style

         - returns: subhead font as UIFont object
         */
        static var subhead: UIFont {
            return ConfigValues.sharedInstance.fontWithIdentifier("subhead")
        }

        /**
         Convenience method to get the font for the footnote style

         - returns: Footnote font as UIFont object
         */
        static var footnote: UIFont {
            return ConfigValues.sharedInstance.fontWithIdentifier("footnote")
        }

        /**
         Convenience method to get the font for the caption1 style

         - returns: Caption1 font as UIFont object
         */
        static var caption1: UIFont {
            return ConfigValues.sharedInstance.fontWithIdentifier("caption1")
        }

        /**
         Convenience method to get the font for the caption2 style

         - returns: Caption2 font as UIFont object
         */
        static var caption2: UIFont {
            return ConfigValues.sharedInstance.fontWithIdentifier("caption2")
        }

        /**
         Convenience method to get any font by id

         Note, that if the identifier string is unknown systemfont of size 14 is returned as a default fallback

         - returns: Font as UIFont object by id or systemfont of size 14
         */
        static func byID(_ fontIdentifier: String) -> UIFont {
            return ConfigValues.sharedInstance.fontWithIdentifier(fontIdentifier)
        }

        /**
         Convenience method to get any font by id

         Note, that if the identifier string is unknown nil is returned

         - returns: Font as UIFont object by id or nil
         */
        static func byIDEventually(_ fontIdentifier: String) -> UIFont? {
            return ConfigValues.sharedInstance.fontWithIdentifierEventually(fontIdentifier)
        }

    }
}
