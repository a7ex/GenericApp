//
//  AppStateConnector.swift

import Foundation

/// This struct is used to connect the network service providers
/// with the session-persistant App State
/// This is actually just a "gateway" to the singleton instance "AppState"
/// where session-persistant data is stored in memory (RAM)

struct AppStateConnector: BackendStateConnector {
    var currentSessionId: String {
        return AppState.currentSessionId
    }
    
    var currentLocaleIdentifier: String {
        return AppState.currentLocaleIdentifier
    }
    
    func updateSessionId(_ sessionId: String?) {
        AppState.updateSessionId(newSid: sessionId)
    }
    
    func updateSessionValidityDate(_ newSessionValidity: Date) {
        AppState.updateSessionValidityDate(newDate: newSessionValidity)
    }
    
    func updateLocaleIdentifier(_ localeId: String?) {
        AppState.updateLocaleIdentifier(newLocaleIdentifier: localeId)
    }
}
