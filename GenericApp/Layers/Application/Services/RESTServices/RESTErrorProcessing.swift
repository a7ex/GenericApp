//
//  RESTErrorProcessing.swift

import Foundation

protocol ServerResponseMetaData {
    var errors: [Error]? { get }
}

struct RESTErrorProcessing {
    private var stateConnector: BackendStateConnector

    init(stateConnector: BackendStateConnector) {
        self.stateConnector = stateConnector
    }

    func processedError<T: ServerResponseMetaData>(for response: T?) -> Error? {
        guard let response = response else { return nil }
        if let errors = response.errors {
            return ServiceError.serverError(message: errors.first?.localizedDescription ?? "<No error description>")
        } else {
            return ServiceError.missingReturnObject(message: "Missing expected object in: \(response)")
        }
    }

    func getFirstBackendError<T: ServerResponseMetaData>(in response: T?) -> Error? {
        guard let response = response else { return nil }
        if let errors = response.errors {
            return ServiceError.serverError(message: errors.first?.localizedDescription ?? "<No error description>")
        }
        return nil
    }
}
