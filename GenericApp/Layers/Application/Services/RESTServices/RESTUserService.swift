//
//  RESTUserService.swift
//  GenericApp
//
//  Created by Alex da Franca on 18.09.17.
//  Copyright © 2017 Deutsche Post Epost. All rights reserved.
//

import Foundation

struct RESTUserService {
    static let serviceName = "user"
    private let connector: BackendConnector
    private var stateConnector: BackendStateConnector
    private let errorProcessor: RESTErrorProcessing
    
    init(connector: BackendConnector, stateConnector: BackendStateConnector) {
        self.connector = connector
        self.stateConnector = stateConnector
        self.errorProcessor = RESTErrorProcessing(stateConnector: stateConnector)
    }
}
