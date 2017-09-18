//
//  StandardButton.swift

import UIKit

@IBDesignable
class StandardButton: UIButton {

    //    var initialBackgroundColor:UIColor!

    private var colorsForStates = [UInt: UIColor]()

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        addTarget(self, action: #selector(StandardButton.wasPressed), for: UIControlEvents.touchDown)
        addTarget(self, action: #selector(StandardButton.wasReleased), for: UIControlEvents.touchUpInside)
        addTarget(self, action: #selector(StandardButton.wasReleased), for: UIControlEvents.touchUpOutside)
        setBackgroundColor(backgroundColor, forState: UIControlState())
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        //Setup shadow here to properly calculate shadowPath
        setupShadow()
    }

    @objc
    func wasPressed() {
        if let bgcolor = colorsForStates[UIControlState.highlighted.rawValue] {
            super.backgroundColor = bgcolor
        }
    }

    @objc
    func wasReleased() {
        super.backgroundColor = colorsForStates[UIControlState().rawValue]
    }

    override var backgroundColor: UIColor? {
        didSet {
            setBackgroundColor(backgroundColor, forState: UIControlState())
            super.backgroundColor = backgroundColor
        }
    }

    @IBInspectable var pressedColor: UIColor? {
        didSet {
            setBackgroundColor(pressedColor, forState: UIControlState.highlighted)
        }
    }

    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var titleSoftShadowRadius: CGFloat = 0 {
        didSet {
            titleLabel?.layer.shadowRadius = titleSoftShadowRadius
        }
    }

    @IBInspectable var softShadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = softShadowRadius
        }
    }

    @IBInspectable var titleSoftShadowOpacity: Float = 0 {
        didSet {
            titleLabel?.layer.shadowOpacity = titleSoftShadowOpacity
            if titleSoftShadowOpacity > 0 {
                titleLabel?.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                titleLabel?.layer.masksToBounds = false
            }
        }
    }

    @IBInspectable var softShadowOpacity: Float = 0 {
        didSet {
            layer.shadowOpacity = softShadowOpacity
            if softShadowOpacity > 0 {
                layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                layer.masksToBounds = false
            }
        }
    }

    @IBInspectable var titleSoftShadowColor: UIColor? {
        didSet {
            titleLabel?.layer.shadowColor = titleSoftShadowColor?.cgColor
        }
    }

    @IBInspectable var softShadowColor: UIColor? {
        didSet {
            layer.shadowColor = softShadowColor?.cgColor
        }
    }

    @IBInspectable var withShadow: Bool = false {
        didSet {
            setupShadow()
        }
    }

    override var isEnabled: Bool {
        didSet {
            super.backgroundColor = isEnabled ? colorsForStates[UIControlState().rawValue]: ConfigValues.Colors.lightTint
        }
    }

    func configureColors(backgroundColor bgColor: UIColor? = nil, textColor: UIColor? = nil) {
        tintColor = textColor
        setTitleColor(textColor, for: UIControlState())
        setTitleColor(ConfigValues.Colors.lightText, for: .disabled)
        if let bgColor = bgColor {
            backgroundColor = bgColor
            pressedColor = bgColor.co_darken()
        }
    }

    func setBackgroundColor(_ color: UIColor?, forState state: UIControlState) {
        colorsForStates[state.rawValue] = color
    }

    // MARK: - Private API

    private func setupShadow() {
        if withShadow {
            let shadowPath = UIBezierPath(rect: bounds)
            softShadowOpacity = Constants.defaultShadowOpacity
            softShadowRadius = Constants.defaultShadowRadius
            softShadowColor = Constants.defaultShadowColor
            layer.shadowPath = shadowPath.cgPath
        } else {
            softShadowOpacity = 0.0
            softShadowRadius = 0.0
            softShadowColor = UIColor.clear
        }
    }

    // UIButton doesn't account the edgeinsets to calculate the intrinsicContentSize
    // so we do it ourselves.
    override var intrinsicContentSize: CGSize {
        let s = super.intrinsicContentSize
        let newWidth = s.width + contentEdgeInsets.left + contentEdgeInsets.right + imageEdgeInsets.left + imageEdgeInsets.right + titleEdgeInsets.left + titleEdgeInsets.right
        let newHeight = s.height + contentEdgeInsets.top + contentEdgeInsets.bottom + imageEdgeInsets.top + imageEdgeInsets.bottom + titleEdgeInsets.top + titleEdgeInsets.bottom
        return CGSize(width: CGFloat(newWidth), height: CGFloat(newHeight))
    }

    private struct Constants {
        static let defaultShadowRadius: CGFloat = 2.0
        static let defaultShadowOpacity: Float = 1.0
        static let defaultShadowColor = UIColor.black.withAlphaComponent(0.35)
    }

}
