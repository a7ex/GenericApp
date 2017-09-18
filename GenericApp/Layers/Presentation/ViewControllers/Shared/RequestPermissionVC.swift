//
//  RequestPermissionVC.swift
//
//  Created by Alex da Franca on 03/06/15.
//  Copyright (c) 2016 Apprime. All rights reserved.
//

import UIKit

/**
 Present RequestPermissionVCHandler to ask user about permissions
 
 This is entirely generic, caller can set Title, Body, Ok- and Cancelbutton label text
 The buttons just call the provided closure, nothong else.
 Caller is responsible for bringing the viewcontroller up and dismissing it
 
 Example:
 ```swift
    let dlog = RequestPermissionVC.initWithMessage(
        "Accessing your location allows us to sort the stores by disance",
        title: "Why enable Location Services?",
        okButtonLabel: "Ok, proceed",
        cancelButtonLabel: "Cancel") { rslt in
 
        if rslt == .OK {
            dismissViewControllerAnimated(true) {
                // do your "Ok" action here
                // or do the "Ok" action and THEN dismiss the viewController
            }
        }
        else {
            // do your "cancel" action here
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    presentViewController(dlog, animated: true, completion: nil)
 ```
 */
class RequestPermissionVC: BaseVC {

    enum AlertButtonType {
        case ok, cancel
    }

    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var explanationText: UILabel!
    @IBOutlet weak var explanationTitleLabel: UILabel!

    var okButtonLabel = LocalizedString("Ok", comment: "Generic permission view: default button label for 'ok' button (maybe overridden by caller)")
    var cancelButtonLabel = LocalizedString("Cancel", comment: "Generic permission view: default button label for 'cancel' button (maybe overridden by caller)")
    var explanationTextContent = "Allow permission?" // this should really be provided by the caller
    var explanationTitleContent = LocalizedString("Why?", comment: "Generic permission view: default text for title (maybe overridden by caller)")
    var hideCancelButton = false

    var actionClosure: ((_ result: AlertButtonType) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        okButton.setTitle(okButtonLabel, for: UIControlState())
        cancelButton.setTitle(cancelButtonLabel, for: UIControlState())
        cancelButton.isHidden = hideCancelButton
        explanationText?.text = explanationTextContent
        explanationTitleLabel?.text = explanationTitleContent
    }

    // MARK: - Convenience initializer

    class func initWithMessage(_ message: String,
                               title: String?=nil,
                               okButtonLabel: String?=nil,
                               cancelButtonLabel: String?=nil,
                               buttonClosure: @escaping ((_ result: AlertButtonType) -> Void)) -> RequestPermissionVC {
        let permissionsCtrl = permissionsController()
        permissionsCtrl.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        permissionsCtrl.explanationTextContent = message
        if let title = title {
            permissionsCtrl.explanationTitleContent = title
        }
        if let okButtonLabel = okButtonLabel {
            permissionsCtrl.okButtonLabel = okButtonLabel
        }
        if let cancelButtonLabel = cancelButtonLabel {
            permissionsCtrl.cancelButtonLabel = cancelButtonLabel
        }
        permissionsCtrl.actionClosure = buttonClosure
        return permissionsCtrl
    }

    private class func permissionsController() -> RequestPermissionVC {
        let mainStoryboard = UIStoryboard(name: Constants.StoryboardName, bundle: nil)
        // swiftlint:disable force_cast
        return mainStoryboard.instantiateViewController(withIdentifier: Constants.OriginatingClassName) as! RequestPermissionVC
        // swiftlint:enable force_cast
    }

    // MARK: - Actions

    @IBAction func cancelButtonTapAction(_ sender: UIButton) {
        actionClosure?(.cancel)
    }

    @IBAction func onButtonTapAction(_ sender: UIButton) {
        actionClosure?(.ok)
    }

    private struct Constants {
        static let OriginatingClassName = "RequestPermissionVC"
        static let StoryboardName = "Main"
    }
}

extension UIViewController {
    func pushFullscreenAlert(withMessage message: String, andTitle title: String, hideCancelButton: Bool = false) {
        let dlog = RequestPermissionVC.initWithMessage(
            message,
            title: title) { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
                if self?.navigationController?.modalPresentationStyle == .fullScreen || self?.navigationController?.modalPresentationStyle == .formSheet {
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    _ = self?.navigationController?.popToRootViewController(animated: true)
                }
        }
        dlog.hideCancelButton = hideCancelButton
        present(dlog, animated: true, completion: nil)
    }
}
