//
//  Credentials.swift

import Foundation

/// Gateway to stored credentials
/// This struct does not store any state or variables
/// Rather the variables and state are stored in the keychain and the user Defaults
struct Credentials {
    let serviceName: String
    let autoLoginUsernameKey: String
    let lastUsernameKey: String

    // accessgroups can be used so that different apps can access the keychain item
    let accessGroup: String?

    let passwordKey = kSecValueData as String

    var storedLastUsername: String? {
        return UserDefaults.standard.string(forKey: lastUsernameKey)
    }

    var autoLoginUsername: String? {
        return UserDefaults.standard.string(forKey: autoLoginUsernameKey)
    }

    func storedPassword(for account: String) -> String {
        do {
            let passwordItems = try KeychainPasswordItem.passwordItems(forService: serviceName, accessGroup: nil)
            if let thisItem = passwordItems.first(where: { $0.account == account }) {
                return try thisItem.readPassword()
            }
        } catch {
            return ""
        }
        return ""
    }

    func storeCredentials(forUser userName: String, password: String) {
        storeUsername(userName)
        storePassword(password, forAccount: userName)
    }

    func storeUsername(_ userName: String) {
        UserDefaults.standard.setValue(userName, forKey: autoLoginUsernameKey)
        UserDefaults.standard.setValue(userName, forKey: lastUsernameKey)
        UserDefaults.standard.synchronize()
    }

    func storePassword(_ password: String, forAccount accountName: String, newAccountName: String? = nil) {
        do {
            var passwordItem = KeychainPasswordItem(service: serviceName, account: accountName, accessGroup: accessGroup)
            if let newAccount = newAccountName,
                accountName != newAccount {
                try passwordItem.renameAccount(newAccount)
            }
            try passwordItem.savePassword(password)
        } catch {
            print("\(error.localizedDescription)")
        }
    }

    func clearAutoLoginUsername() {
        UserDefaults.standard.removeObject(forKey: autoLoginUsernameKey)
        UserDefaults.standard.synchronize()
    }
}
