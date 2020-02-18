//
//  UILabel+Extension.swift
//  eHatid
//
//  Created by Julius Camba Abarra on 2/15/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {

    /// Emphasizes specific text in a string by changing its color and font.
    ///
    /// - Parameters:
    ///     - searchedText: Specific text in a string
    ///     - color: An instance of `UIColor` defaulting to `red`
    ///     - font: An instance of `UIFont`
    /// - Returns: None
    public func highlight(searchedText: String, color: UIColor = UIColor.red, font: UIFont) {
        guard let textLabel = self.text else {
            logger.error("Can't hightlight text.")
            return
        }

        let attributeText: NSMutableAttributedString = NSMutableAttributedString(string: textLabel)
        let range: NSRange = attributeText.mutableString.range(of: searchedText, options: [])
        attributeText.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        attributeText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        
        self.attributedText = attributeText
    }

}
