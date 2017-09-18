//
//  ButtonWithGradientBG.swift

import UIKit

enum GradientDirection {
    case left, right, top, bottom
}

class ButtonWithGradientBG: UIButton {

    var direction = GradientDirection.left

    override func awakeFromNib() {
        super.awakeFromNib()
        addGradientView()
    }

    private final func addGradientView() {
//        let gradient = UIView()
//        gradient.backgroundColor = UIColor(colorLiteralRed: 0.5, green: 0, blue: 0, alpha: 0.3)
        setBackgroundImage(#imageLiteral(resourceName: "fadeWhiteHorizontal"), for: .normal)
    }
}
