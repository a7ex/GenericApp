//
//  OverlayView.swift
//  MovingLab
//
//  Created by Alex da Franca on 29.05.17.
//  Copyright © 2017 apprime. All rights reserved.
//

import UIKit

/**
 Type of OverlayView
 
 currently there is only one: fullscreen gray with white large activity indicator
 and a white label below the centered activity indicator
 */
enum OverlayViewType {
    case activityIndicatorFullscreenGray
}

/**
 Simple "cover view" to darken the whole view and display an activity indictor and block all UI
 
 This view is used to block all UI in a modal way during an asynchronous task,
 which shall force the user to wait for the completion. Not all asynchronous tasks
 really need to block further UI, but some taks must first be completed before the user
 can proceed. For that case bring up this OverlayView using the "showActivityIndicator()"
 method, which is common to all ViewControllers inheriting from BaseVC (all VCs of this app)
 
 Always use showActivityIndicator() to show the overlay and animate the activity indicator
 and to set or change the status message. Calling showActivityIndicator() while the overlay
 is showing just updates the message text.
 
 Use hideActivityIndicator() to dismiss the overlay and return control back to the user
 
 So to use this class refer to ActivityIndicatorExtension.swift
 */

class OverlayView: UIView {
    /* While the follwoing variables (and part of the interface) are not private
     you do not typically interact with them directly.
     The "manager" of this view is typically the view controller
     in our case the BaseVC, which interacts with the "public interface" of this class
    */
    var type = OverlayViewType.activityIndicatorFullscreenGray // default
    var overlayAlphaValue = 0.2
    var activityIndicator: UIActivityIndicatorView?
    var statusLabel: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    init(type: OverlayViewType) {
        super.init(frame: CGRect.zero)
        self.type = type
        setup()
    }

    // MARK: - Public

    final func startAnimating() {
        activityIndicator?.startAnimating()
    }

    final func stopAnimating() {
        activityIndicator?.stopAnimating()
    }

    final func setStatusMessage(_ msg: String?) {
        statusLabel?.text = msg
    }

    // MARK: - Private

    private final func setup() {
        switch type {
        case .activityIndicatorFullscreenGray:
            setupActivityIndicatorViews()
        }
    }

    final func setupActivityIndicatorViews() {
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        }
        guard let activityIndicator = activityIndicator else { return }
        addSubview(activityIndicator)

        backgroundColor = UIColor(white: CGFloat(0), alpha: CGFloat(overlayAlphaValue))

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        addConstraint(NSLayoutConstraint(
            item: activityIndicator,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: CGFloat(1.0),
            constant: CGFloat(0)
            )
        )

        addConstraint(NSLayoutConstraint(
            item: activityIndicator,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerY,
            multiplier: CGFloat(1.0),
            constant: CGFloat(0)
            )
        )

        if statusLabel == nil {
            statusLabel = UILabel()
        }
        if let lab = statusLabel {
            addSubview(lab)
            lab.translatesAutoresizingMaskIntoConstraints = false
            lab.font = ConfigValues.Fonts.caption2
            lab.textColor = UIColor.white
            lab.numberOfLines = 0
            lab.lineBreakMode = .byWordWrapping
            lab.textAlignment = .center

            addConstraint(NSLayoutConstraint(
                item: lab,
                attribute: .top,
                relatedBy: .equal,
                toItem: activityIndicator,
                attribute: .bottom,
                multiplier: CGFloat(1.0),
                constant: CGFloat(8)
                )
            )

            addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-(40)-[statusLabel]-(40)-|",
                options: NSLayoutFormatOptions(),
                metrics: nil,
                views: ["statusLabel": lab])
            )
        }
    }
}
