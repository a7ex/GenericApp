//
//  GradientView.swift

import UIKit

@IBDesignable
class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }

    override var backgroundColor: UIColor? {
        didSet {
            setupView()
        }
    }

    @IBInspectable var foregroundColor: UIColor = UIColor.black {
        didSet {
            setupView()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private final func setupView() {
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.colors = [(backgroundColor ?? UIColor.white).cgColor, foregroundColor.cgColor]
    }
}
