//
//  AppState.swift

import Foundation

/// Singleton which stores the session-persistant App State in memory (RAM)

class AppState {
    private struct Constants {
        struct UserDefaultKeys {
            
        }
        struct LaunchArguments {
            static let runningTests = "-RUNNING_TESTS"
        }
    }

    private static let sharedInstance = AppState()
    private var currentSessionId = "" {
        didSet {
            if currentSessionId.isEmpty {
                clearStoredUserData()
            }
        }
    }
    private var sessionValidityDate = Date.distantFuture
    private var currentLocaleIdentifier = Locale.current.identifier // "de_DE" // Locale.current.identifier

    class var currentSessionId: String {
        return sharedInstance.currentSessionId
    }
    
    class func updateSessionId(newSid: String?) {
        sharedInstance.currentSessionId = newSid ?? ""
    }
    
    class func updateSessionValidityDate(newDate newSessionValidity: Date) {
        sharedInstance.sessionValidityDate = newSessionValidity
    }
    
    class var currentLocaleIdentifier: String {
        return sharedInstance.currentLocaleIdentifier
    }
    
    class var currentLocale: Locale {
        return Locale(identifier: sharedInstance.currentLocaleIdentifier)
    }
    
    class func updateLocaleIdentifier(newLocaleIdentifier: String?) {
        sharedInstance.currentLocaleIdentifier = newLocaleIdentifier ?? Locale.current.identifier
    }
    
    private final func clearStoredUserData() {
        // e.g.: currentUserProfile = nil
    }
}
