//
//  UIColor+Extension.swift
//  eHatid
//
//  Created by Julius Abarra on 2/14/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    /// Creates color based on the given hexadecimal in string.
    ///
    /// - Parameter hex: A hexadecimal value in string
    /// - Returns: An instance of `UIColor`
    public func color(fromHexString hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
