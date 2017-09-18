//
//  Email.swift
//  MovingLab
//
//  Created by Alex da Franca on 29.05.17.
//  Copyright © 2017 apprime. All rights reserved.
//

import Foundation
import MessageUI

/**
 Simple Email object, which contains email address, subject and email body

 It supports to be sent using the built-in iOS mail app
 or
 Create a MFMailComposeViewController with this email to be shown by another viewController (Compose and send the Email inline)

 All properties are optional, as the user can fill them in later
 */

struct Email {
    let address: String?
    let subject: String?
    let mailBody: String?
    let isHTMLMail = false

    func createMFMailComposerController() -> MFMailComposeViewController? {
        if MFMailComposeViewController.canSendMail() {
            let mailContr = MFMailComposeViewController()
            if let subject = subject.nonEmptyString {
                mailContr.setSubject(subject)
            }
            if let address = address.nonEmptyString {
                mailContr.setToRecipients([address])
            }
            if let mailBody = mailBody.nonEmptyString {
                mailContr.setMessageBody(mailBody, isHTML: isHTMLMail)
            }
            return mailContr
        }
        return nil
    }

    /**
     Launch the Mail application on the device
     */
    func sendByIOSMailApp() {
        var emailString =  "mailto:"
        if let address = address.nonEmptyString { emailString = emailString.appendingFormat("%@?", address) }
        if let subject = subject.nonEmptyString {
            emailString = emailString.appendingFormat("?subject=%@", subject)
            if let mailBody = mailBody.nonEmptyString { emailString = emailString.appendingFormat("&body=%@", mailBody) }
        } else if let mailBody = mailBody.nonEmptyString {
            emailString = emailString.appendingFormat("?body=%@", mailBody)
        }
        if let emailStringEscaped = emailString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL(string: emailStringEscaped) {
            UIApplication.shared.open(url, options: [String: Any](), completionHandler: nil)
        } else {
            print("Warning: Could not send mail by iOS mail app, because URL could not be created from string: \(emailString)")
        }
    }
}
