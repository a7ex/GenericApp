//
//  CommonUICallsExtension.swift

import UIKit

/**
 *  Common UI calls, which are available to all our ViewControllers
 */

extension UIViewController {
    /**
     Log didReceiveMemoryWarning messages to the server
     
     This should only be called at the end of the parent/child hierarchy of our subclasses to UIViewControllers
     So that we log a warning to the server only once, but provide the name of the "topmost" subclass,
     which received the memory warning. So we use reflection here to get the name of the class
     */
    func logMemoryWarning() {
        if let classname = Mirror(reflecting:self).description.components(separatedBy: ".").last {
            print("\(classname): didReceiveMemoryWarning")
//            AppController.logWarning("didReceiveMemoryWarning", originatingClass:classname)
        }
    }

    /**
     Log error message to the server and (optionally) show alert to user
     
     Convenience method to log error to the server AND show alert to the user, IF an userMessage is provided
     
     - parameter message:          String to log to the server
     - parameter originatingClass: String with the classname of the class, where the error occurred
     - parameter userMessage:      String (optional) message to display to the user in an alert, if nil or "", then no alert is displayed to the user
     */
    func logErrorToBackendServer(_ message: String, originatingClass: String, userMessage: String?="") {
//        AppController.logError(message, originatingClass: originatingClass)
        if let userMessage = userMessage.nonEmptyString { informUserAbout(userMessage) }
    }

    /**
     Log warning message to the server and (optionally) show alert to user
     
     Convenience method to log warning to the server AND show alert to the user, IF an userMessage is provided
     
     - parameter message:          String to log to the server
     - parameter originatingClass: String with the classname of the class, where the warning occurred
     - parameter userMessage:      String (optional) message to display to the user in an alert, if nil or "", then no alert is displayed to the user
     */
    func logWarningToBackendServer(_ message: String, originatingClass: String, userMessage: String?="") {
//        AppController.logWarning(message, originatingClass:originatingClass)
        if let userMessage = userMessage.nonEmptyString { informUserAbout(userMessage) }
    }

    /**
     Put up a simple alert with a message to the user and an OK button to dismiss
     
     - parameter message: string for alert message
     - parameter title:   string for alert title (optional parameter. Default is "")
     */
    func informUserAbout(_ message: String, title: String?="") {
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okbutton = UIAlertAction(title: "Ok", style: .default) { (_) -> Void in

        }
        alertCtrl.addAction(okbutton)
        present(alertCtrl, animated: true, completion: nil)
    }

    /**
     Put up a simple alert with a message to the user and an OK button to dismiss
     
     - parameter message: string for alert message
     - parameter title:   string for alert title (optional parameter. Default is "")
     - parameter okAction:   action when user tap on Ok button
     - parameter showCancelButton: define if cancel button will be presented
     */
    func informUserAbout(_ message: String, title: String?="", okAction: @escaping (() -> Void), cancelAction: (() -> Void)? = nil) {
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okbutton = UIAlertAction(title: "Ok", style: .default) { (_) -> Void in
            okAction()
        }
        if let cancelAction = cancelAction {
            let cancelbutton = UIAlertAction(title: LocalizedString("Cancel", comment: "No title for the alert button"), style: .default) { (_) -> Void in
                cancelAction()
            }
            alertCtrl.addAction(cancelbutton)
        }
        alertCtrl.addAction(okbutton)
        present(alertCtrl, animated: true, completion: nil)
    }

    /**
     Put up a simple alert with a message to the user and predefined buttons with custom action callback
     
     - parameter message: string for alert message
     - parameter title:   string for alert title (optional parameter. Default is "")
     - parameter actions:   tuple with button title and tap calback
     */
    func informUserAbout(_ message: String, title: String?="", withActions actions: [(String, () -> Void)]) {
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)

        for action in actions {
            let alertButton = UIAlertAction(title: action.0, style: .default) { (_) -> Void in
                action.1()
            }
            alertCtrl.addAction(alertButton)
        }
        present(alertCtrl, animated: true, completion: nil)
    }

    /**
     Bring up an alert with a text entry line
     
     Example:
     let msg = NSString(format: LocalizedString("Name the new %@", comment: "alert message (instruction) to create a new item"), self.entityTitle())
     let okButtonText = LocalizedString("Create", comment:"create button text")
     let placeholderText = NSString(format: LocalizedString("New %@", comment: "Default name of new item"), self.entityTitle())
     requestArbitraryStringFromUser(message:msg, title:nil, placeHolder:placeholderText, okButtonText:okButtonText) { enteredString in
     print("String which the user entered is: \(enteredString)")
     }
     
     - parameter message:      string for message of the alert
     - parameter title:        string for title of the alert (optional parameter. Default is "")
     - parameter placeHolder:  string for placeholder text for the text entry line (optional parameter. Default is "Enter text here")
     - parameter okButtonText: string for Ok button text (optional parameter. Default is "Ok")
     - parameter response:     closure which gets the string, which the user entered
     */
    func requestArbitraryStringFromUser(message: String, title: String?="", placeHolder: String?="Enter text here", okButtonText: String?="Ok", response:@escaping (String?) -> Void) {

        let alrt: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)

        let cancel: UIAlertAction = UIAlertAction(title: LocalizedString("Cancel", comment:"Shared code: cancel button text"), style: UIAlertActionStyle.cancel, handler: {(_) in
            alrt.dismiss(animated: true, completion: nil)
            response(nil)
        })
        alrt.addAction(cancel)

        let ok: UIAlertAction = UIAlertAction(title: okButtonText ?? "Ok", style: UIAlertActionStyle.default, handler: {(_) in
            let str = alrt.textFields?[0].text ?? ""
            response(str)
        })
        alrt.addAction(ok)

        alrt.addTextField(configurationHandler: {(txtField: UITextField) -> Void in
            txtField.placeholder = placeHolder ?? "Enter text here"
        })

        self.present(alrt, animated: true, completion:nil)
    }

    typealias AlertActionClosure = ((_ alert: UIAlertAction?) -> Void)
    /**
     Put up a customizable alert with a message, title and configurable buttons
     
     - parameter message: string for alert message
     - parameter title:   string for alert title (optional parameter. Default is "")
     - parameter buttons: array with a tuple of buttontitle (String), buttonStyle and closure
     
     Example:
     *     showAlert(message: "That's the message", title: "This is the title", buttons:
     *             [
     *                 ("Ok", .Default, { (action) in
     *                      print("Ok button pressed")
     *                 }),
     *                 ("Cancel", .Cancel, { (action) in
     *                      print("Cancel button pressed")
     *                 }),
     *                 ("Delete", .Destructive, { (action) in
     *                      print("Delete button pressed")
     *                 })
     *             ]
     *         )
     */
    func showAlert(message: String, title: String?="", buttons:[(buttonTitle: String, buttonStyle: UIAlertActionStyle, closure: AlertActionClosure)]) {
        alert(message: message, title: title, alertStyle: .alert, buttons: buttons)
    }

    /**
     Put up a customizable actionSheet with a message, title and configurable buttons
     
     - parameter message: string for alert message
     - parameter title:   string for alert title (optional parameter. Default is "")
     - parameter buttons: array with a tuple of buttontitle (String), buttonStyle and closure
     
     Example:
     *     showActionSheet(message: "That's the message", title: "This is the title", buttons:
     *             [
     *                 ("Ok", .Default, { (action) in
     *                      print("Ok button pressed")
     *                 }),
     *                 ("Cancel", .Cancel, { (action) in
     *                      print("Cancel button pressed")
     *                 }),
     *                 ("Delete", .Destructive, { (action) in
     *                      print("Delete button pressed")
     *                 })
     *             ]
     *         )
     */
    func showActionSheet(message: String, title: String?="", buttons:[(buttonTitle: String, buttonStyle: UIAlertActionStyle, closure: AlertActionClosure)]) {
        alert(message: message, title: title, alertStyle: .actionSheet, buttons: buttons)
    }

    /**
     Return previous navigation controller in Navigation Stack
     */
    func previousViewController() -> UIViewController? {
        guard let controllers = navigationController?.viewControllers,
            controllers.count > 1 else {
                return nil
        }
        switch controllers.count {
        case 2:
            return controllers.last
        default:
            return controllers.dropLast(1).last
        }
    }

    // MARK: - Private methods

    private func alert(message: String?, title: String?="", alertStyle: UIAlertControllerStyle, buttons:[(buttonTitle: String, buttonStyle: UIAlertActionStyle, closure: AlertActionClosure)]) {
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        for (buttonText, buttonStyle, alertAction) in buttons {
            let thisButton = UIAlertAction(title: buttonText, style: buttonStyle, handler: alertAction)
            alertCtrl.addAction(thisButton)
        }
        present(alertCtrl, animated: true, completion: nil)
    }
}
