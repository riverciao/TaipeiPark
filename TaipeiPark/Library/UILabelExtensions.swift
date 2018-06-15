//
//  UILabelExtensions.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/15.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

extension UILabel {
    /// Set paragraph style after text is assigned in label.
    func setParagraphStyle(lineSpacing: CGFloat = 0, paragraphSpacingBefore: CGFloat = 0, characterSpacing: CGFloat = 1) {
        guard let labelText = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacingBefore = paragraphSpacingBefore
        
        let attributedString: NSMutableAttributedString
        if let labelAttributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        attributedString.addAttributes([.paragraphStyle: paragraphStyle], range: NSMakeRange(0, attributedString.length))
        attributedString.addAttributes([.kern: characterSpacing], range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}
