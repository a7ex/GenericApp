//
//  RESTServices.swift
//  GenericApp
//
//  Created by Alex da Franca on 18.09.17.
//  Copyright © 2017 Deutsche Post Epost. All rights reserved.
//

import Foundation

struct RESTServices {
    private let connector: BackendConnector
    private let stateConnector: BackendStateConnector
    
    // available services:
    let user: RESTUserService
    
    init(connector: BackendConnector, stateConnector: BackendStateConnector) {
        self.connector = connector
        self.stateConnector = stateConnector
        
        // instantiate available services:
        user = RESTUserService(connector: connector, stateConnector: stateConnector)
    }
}
