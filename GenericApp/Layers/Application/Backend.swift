//
//  Backend.swift

import Foundation

enum ServiceError: Error {
    case none
    case unableToCreateDTO
    case missingReturnObject(message: String)
    case serverError(message: String)
}

extension ServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .none:
            return "No error"
        case .unableToCreateDTO:
            return "Unable to map result to expected DTO"
        case .missingReturnObject(let message):
            return message
        case .serverError(let message):
            return message
        }
    }
}

/// all connectors to the server backend must conform to the following protocol
/// which includes the protocol to interface with the backend services
protocol BackendConnector {
    func login(userName: String, password: String, completion: ((Any?, Error?) -> Void)?)
    func logout()
    func signUp(password: String, firstName: String, lastName: String, email: String, completion: ((Any?, Error?) -> Void)?)
}

/// The services need a persistent store for the sessionId and locale setting
/// which must conform to this protocol
protocol BackendStateConnector {
    var currentSessionId: String { get }
    var currentLocaleIdentifier: String { get }
    func updateSessionId(_ sessionId: String?)
    func updateSessionValidityDate(_ newSessionValidity: Date)
    func updateLocaleIdentifier(_ localeId: String?)
}

/// The central connector to any server backend
struct Backend: BackendConnector {

    private struct Constants {
        struct TaskId {
            static let loginToParse = "loginToParseTask"
            static let loginToAIM = "loginToAIMTask"
            static let preloadEnums = "preloadEnumsTask"
            static let registerInParse = "registerInParseTask"
            static let registerInAIM = "registerInAIMTask"
        }
        struct Error {
            static let UnableToLogin = LocalizedString("Unknown error. Unable to log into the backend.", comment: "BackendConnector: if anything goes wrong when logging in, but we do not get an error message")
        }
    }
    let connector: BackendConnector // load data from the network
    let services: RESTServices // provide services objects (-> backendInstance.services.service.method)

    static var defaultBackend: Backend {
        return Backend(connector: RestBackend(), stateConnector: AppStateConnector())
    }

    init(connector: BackendConnector, stateConnector: BackendStateConnector) {
        self.connector = connector
        services = RESTServices(connector: connector, stateConnector: stateConnector)
    }
    
    func login(userName: String, password: String, completion: ((Any?, Error?) -> Void)?) {
    }
    
    func logout() {
        connector.logout()
    }
    
    func signUp(password: String, firstName: String, lastName: String, email: String, completion: ((Any?, Error?) -> Void)?) {
    }
}
