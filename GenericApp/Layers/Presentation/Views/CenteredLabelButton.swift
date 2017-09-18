//
//  CenteredLabelButton.swift

import UIKit

/**
  This subclass of UIButton centers the button label below the button image.

  It will be recalculated on layoutSubviews, so a title change will update the margins
 
  NOTE, that in IB this will not appear correctly, as layoutSubviews() is not called for @IBDesignables
*/
class CenteredLabelButton: UIButton {

    override func layoutSubviews() {
        centerButtonLabel()
        super.layoutSubviews()
    }
    
    override var intrinsicContentSize : CGSize {
        let labelSize = titleRect(forContentRect: frame).size
        let imageSize:CGSize = imageRect(forContentRect: frame).size
        return CGSize(width: CGFloat(max(labelSize.width, imageSize.width)), height: CGFloat(labelSize.height + imageSize.height))
    }

    private final func centerButtonLabel() {
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .bottom
        let imageSize:CGSize = imageRect(forContentRect: frame).size
        
        if imageSize.equalTo(CGSize.zero) || titleLabel?.text == nil {
            return
        }
        
        // Funny enough for the HORIZONTAL inset of the image, I don't need the REAL width of the label
        // but rather I need the width, which the label WOULD have, if it wouldn't be truncated and in one single line
        // to me that looks like a bug in UIButton, as it doesn't seem to take truncation into consideration
        // so instead of using [self titleRectForContentRect:self.frame].size,
        // I will use:
        let titleSizeUntruncated:CGSize = NSAttributedString(string:titleLabel!.text!, attributes:[NSAttributedStringKey.font: titleLabel!.font]).boundingRect(with: CGSize(width:2000, height:2000), options:.usesLineFragmentOrigin, context:nil).size
        
        // Nonetheless the VERTICAL inset is taken from the actual height of the text, which
        // in case of self.linebreakmode = wordwrap for example might be higher than one line
        
        let titleSize:CGSize = titleRect(forContentRect: frame).size
        titleEdgeInsets = UIEdgeInsets(top: 0.0, left: imageSize.width * -1, bottom: 0, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: titleSize.height, right: titleSizeUntruncated.width * -1)
        
        invalidateIntrinsicContentSize()
    }
}
