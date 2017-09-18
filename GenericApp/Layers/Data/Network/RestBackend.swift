//
//  RestBackend.swift

import Foundation

/// Interface with Rest Server
///
/// This struct provides the necessary methods to communicate with the Backend Server

struct RestBackend: BackendConnector {

    // MARK: - Protocol compliance:

    /// Login
    ///
    /// - Parameters:
    ///   - userName: username on the Parse Server
    ///   - password: corresponding password
    ///   - completion: result closure with an error on failure or nil on success
    func login(userName: String, password: String, completion: ((Any?, Error?) -> Void)?) {
    }

    /// Logout
    func logout() {
    }

    /// Regsiter new user
    ///
    /// - Parameters:
    ///   - userName: a non-nil string used for username
    ///   - password: a non-nil string used for password
    ///   - email: a valid email address
    ///   - completion: result closure with an error on failure or nil on success
    func signUp(password: String, firstName: String, lastName: String, email: String, completion: ((Any?, Error?) -> Void)?) {
    }
}
