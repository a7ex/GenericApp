//
//  MailAndWebExtension.swift

import UIKit
import MessageUI

extension UIViewController: MFMailComposeViewControllerDelegate {

    private struct ConfirmOpenUrlAlertStruct {
        let title = LocalizedString("Open %@ in Safari", comment: "Confirm open url alert: title (placeholder: url)")
        let cancelButtonText = LocalizedString("Cancel", comment:"Mail composing: cancel button text")
        let okButtonText = LocalizedString("Open URL", comment: "Open URL confirmation alert open url button text")
        let unableToOpenURLAlerttext = LocalizedString("Unable to open URL", comment: "Unable to open URL alert: title")
    }
    private final func confirmOpenUrlAlertStrings() -> ConfirmOpenUrlAlertStruct {
        return ConfirmOpenUrlAlertStruct()
    }
    private struct ConfirmCallAlertStruct {
        let title = LocalizedString("Call %@", comment: "Confirm call alert: title (placeholder: phonenumber)")
        let okButtonText = LocalizedString("Call", comment: "Call confirmation alert call button text")
        let unableToCallAlerttext = LocalizedString("Unable to call", comment: "Unable to call alert: title")
    }
    private final func confirmCallAlertStrings() -> ConfirmCallAlertStruct {
        return ConfirmCallAlertStruct()
    }

    /**
     Switch to the iOS Settings app
     
     (For example to change the notifications settings)
     
     */
    final func openSettings() {
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(url, options: [String: Any](), completionHandler: nil)
        }
    }

    final func sendMail(_ email: Email) {

        if let mailController = email.createMFMailComposerController() {
            mailController.mailComposeDelegate = self
            //        if ([mailController.view respondsToSelector:@selector(setTintColor:)])
            //            [mailController.view setTintColor:[UIColor redColor]];

            present(mailController, animated: true, completion: nil)
        } else {
            email.sendByIOSMailApp()
        }
    }

    // MFMailComposeViewController delegate method
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - open website

    /**
     Open URL in external web browser (MobileSafari)
     
     This method optionally shows an alert before leaving the app twoards the external App,
     so that the user is not surprised by suddenly being sent to another app
     
     Use an empty string or nil, if you want no alert to be shown
     
     - parameter urlString:  absolute (fully qualifies) URL as string
     - parameter promptUser: Prompt string for the alert with the Ok/Cancel button (empty string => no alert)
     */
    final func openURLInBrowser(_ urlString: String?, promptUser: String?) {
        guard let urlString = urlString.nonEmptyString else { return }

        if let promptUser = promptUser.nonEmptyString {
            showAlert(message: "", title: promptUser, buttons: [
                (buttonTitle: confirmOpenUrlAlertStrings().cancelButtonText, buttonStyle:UIAlertActionStyle.cancel, closure: { (action) in
                }),
                (buttonTitle: confirmOpenUrlAlertStrings().okButtonText, buttonStyle:UIAlertActionStyle.default, closure: { (action) in
                    self.openURLFinally(urlString)
                })])
        } else {
            openURLFinally(urlString)
        }
    }

    private final func appendHTMLExtensionIfNecessary(_ urlString: String) -> String {
        if urlString.hasSuffix(".html") { return urlString }
        if urlString.hasSuffix(".htm") { return urlString }
        if urlString.contains("?") { return urlString }
        return "\(urlString).html"
    }

    private final func encodeURLString(_ urlString: String, withParamString paramString: String) -> URL? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        let mutableURLRequest = URLRequest(url: url)
        let encoding = URLEncoding()

        var urlParamDictionary = [String: String]()
        let paramPairs = paramString.components(separatedBy: "&")
        if !paramPairs.isEmpty {
            for paramPair in paramPairs {
                let parts = paramPair.components(separatedBy: "=")
                if parts.count < 2 { continue }
                if let key = parts[0].removingPercentEncoding,
                    let value = parts[1].removingPercentEncoding?.replacingOccurrences(of: "+", with: " ") {
                    urlParamDictionary[key] = value
                }
            }
        }

        let newUrl: URL?

        do {
            newUrl = try encoding.encode(CustomRequest(request: mutableURLRequest), with: urlParamDictionary).url
        } catch {
            return nil
        }

        return newUrl
    }

    private final func normalizeURLString(_ urlString: String?) -> URL? {
        if var urlStr = urlString {
            if urlStr.hasPrefix("www.") {
                urlStr = "http://" + urlStr
            }
            let retval = URL(string: urlStr)

            if retval == nil {
                let parts = urlStr.components(separatedBy: "?")
                if parts.count > 1 {
                    return encodeURLString(parts[0], withParamString: parts[1])
                }
            }
            return retval
        }
        return nil
    }

    private final func openURLFinally(_ urlString: String?) {
        if let url = normalizeURLString(urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [String: Any](), completionHandler: nil)
            }
        } else {
            informUserAbout(confirmOpenUrlAlertStrings().unableToOpenURLAlerttext, title: nil)
        }
    }

    // MARK: - call phone number

    final func callPhoneNumber(_ phoneNumber: String) {

        showAlert(message: "", title: String(format: confirmCallAlertStrings().title, phoneNumber), buttons: [
            (buttonTitle: confirmOpenUrlAlertStrings().cancelButtonText, buttonStyle: UIAlertActionStyle.cancel, closure: { (action) in
            }),
            (buttonTitle: confirmCallAlertStrings().okButtonText, buttonStyle: UIAlertActionStyle.default, closure: { [unowned self] (action) in
                self.callPhoneNumberFinally(phoneNumber)
            })
            ])
    }

    final func callPhoneNumberFinally(_ phoneNumber: String) {
        if let formattedNumber = self.normalizePhoneNumber(phoneNumber) {
            let number = "tel://" + formattedNumber
            if let url = URL(string: number),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [String: Any](), completionHandler: nil)
            } else {
                self.informUserAbout(confirmCallAlertStrings().unableToCallAlerttext, title: nil)
            }
        } else {
            self.informUserAbout(confirmCallAlertStrings().unableToCallAlerttext, title: nil)
        }
    }

    private final func normalizePhoneNumber(_ phoneNumber: String) -> String? {
        let formattedNumber = phoneNumber.characters.filter({"+0123456789".characters.contains($0)}).map {"\($0)"}.joined(separator: "")
        return formattedNumber.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)
    }
}

struct CustomRequest: URLRequestConvertible {
    var urlRequest: URLRequest

    init(request: URLRequest) {
        urlRequest = request
    }

    public func asURLRequest() throws -> URLRequest {
        return urlRequest
    }
}
