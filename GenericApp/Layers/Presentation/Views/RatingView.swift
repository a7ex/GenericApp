//
//  RatingView.swift
//  conradkiosk
//
//  Created by Alex da Franca on 12/05/15.
//  Copyright (c) 2015 Conrad Electronics SE. All rights reserved.
//

import UIKit

/**
 @IBDesignable control for a "star rating" control
 
 The single "stars" can be provided as images ()so the control doesn't necessarly need to be a star control) OR, in case no image is provided, the image for the stars is created using a bezierpath (This requires the extension "BezierPath+COAdditions.swift")
 */

@IBDesignable
class RatingView: UIControl {
    
    /** Number of stars
     - returns: Integer
     */
    @IBInspectable var numberOfStars: Int = 5 {
        didSet {
            createMaskView()
        }
    }
    
    /** Current rating value (normalized)
     *  Range: from 0.0 to 1.0
     - returns: Double
     */
    @IBInspectable var currentRating: Double = 0.0 {
        didSet {
            currentRating = max(0.0, min(1.0, currentRating)) // clip to value range from 0.0 - 1.0
            let newWidth = intrinsicContentSize.width * CGFloat(currentRating)
            ratingPercentView.frame = CGRect(x: 0, y: 0, width: newWidth, height: frame.size.height)
        }
    }
    
    /** Image object for the star artwork
     - returns: UIImage
     */
    @IBInspectable var staticStarImage:UIImage? {
        didSet {
            if let img = staticStarImage {
                starImage = img
            }
        }
    }
    
    /** Size of the star image (in case it is automatically generated from a bezierpath)
     - returns: CGFloat
     */
    @IBInspectable var starSize:CGFloat = 20.0 {
        didSet {
            defer { invalidateIntrinsicContentSize() }
            if let _ = staticStarImage {
                return
            }
            else {
                starImage = createComputedStarImage(starSize)
                let newWidth = frame.size.width * CGFloat(currentRating)
                ratingPercentView.frame = CGRect(x: 0, y: 0, width: newWidth, height: frame.size.height)
                createMaskView()
            }
        }
    }
    
    /** Whether the current rating value is user editable (tap and swipe) or read-only
     - returns: Bool
     */
    @IBInspectable var editable:Bool = false {
        didSet {
            #if !TARGET_INTERFACE_BUILDER
                if editable {
                    isUserInteractionEnabled = true
                    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RatingView.tapOnView(_:))))
                    addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(RatingView.panOnView(_:))))
                }
                else {
                    if let gestRecognizers = gestureRecognizers {
                        for thisGesture in gestRecognizers {
                            removeGestureRecognizer(thisGesture)
                        }
                    }
                }
            #endif
        }
    }
    
    var starImage:UIImage! {
        didSet {
            createMaskView()
        }
    }
    
    // MARK: - overrides
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAssets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupAssets()
    }
    
    convenience init(ratingStarImage:UIImage) {
        self.init(frame:CGRect(x: 0, y: 0, width: 100, height: 100))
        starImage = ratingStarImage
    }
    
    override var intrinsicContentSize : CGSize {
        let sz = (staticStarImage != nil) ? staticStarImage!.size: CGSize(width: starSize, height: starSize)
        return CGSize(width: sz.width * CGFloat(numberOfStars), height: sz.height)
    }
    
    override func sizeToFit() {
        super.sizeToFit()
        frame = CGRect(origin: frame.origin, size: intrinsicContentSize)
    }
    
    // MARK: - Interaction
    
    @objc
    func tapOnView(_ recognizer: UITapGestureRecognizer) {
        currentRating = ratingAtPoint(recognizer.location(in: self))
        sendActions(for: .editingDidEnd)
    }
    
    @objc
    func panOnView(_ recognizer: UIPanGestureRecognizer) {
        currentRating = ratingAtPoint(recognizer.location(in: self))
        sendActions(for: .editingDidEnd)
    }
    
    // MARK: - Private interface
    
    private final var starImageMask:UIView!
    private final var ratingPercentView = UIView()
    
    private func setupAssets() {
        if let img = staticStarImage {
            starImage = img
        }
        else {
            starImage = createComputedStarImage(starSize)
        }
        ratingPercentView.backgroundColor = tintColor
        if ratingPercentView.superview == nil {
            addSubview(ratingPercentView)
        }
    }
    
    private final func createMaskView() {
        let starSize = starImage.size
        starImageMask = UIView(frame: CGRect(x: 0, y: 0, width: starSize.width * CGFloat(numberOfStars), height: starSize.height))
        var targetFrame = CGRect(x: 0, y: 0, width: starSize.width, height: starSize.height)
        for _ in 0..<numberOfStars {
            let img = UIImageView(image: starImage)
            img.frame = targetFrame
            targetFrame = targetFrame.offsetBy(dx: starSize.width, dy: 0)
            starImageMask.addSubview(img)
        }
        mask = starImageMask
    }
    
    private final func createComputedStarImage(_ sizeOfStar:CGFloat) -> UIImage {
        let bezier = UIBezierPath()
        bezier.drawStarBezier(x: 0, y: 0, radius: sizeOfStar/4, sides: 5, pointyness: 2, angleAdjustment:-18)
        //Commented this code because it hide around 2px of star from the bottom
        //        let verticalAdjustment = Int(sizeOfStar / 5.0) - 1
        //        if verticalAdjustment > 0 {
        //            bezier.apply(CGAffineTransform(translationX: 0, y: CGFloat(verticalAdjustment))) // odd...
        //        }
        
        let scale = traitCollection.displayScale
        return bezier.imageRepresentationWithFillColor(UIColor.black, scale: scale)
    }
    
    private final func ratingAtPoint(_ localPoint: CGPoint) -> Double {
        return Double(localPoint.x / frame.width)
    }
    
}
