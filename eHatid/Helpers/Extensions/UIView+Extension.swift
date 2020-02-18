//
//  UIView+Extension.swift
//  eHatid
//
//  Created by Julius Abarra on 2/14/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    /// Adds an instance of `UIView` to the view.
    ///
    /// - Parameter subview: An instance of `UIView`
    /// - Returns: None
    func subview(forAutoLayout subview: UIView) {
        self.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Adds instances of `UIView` to the view.
    ///
    /// - Parameter subviews: Array of `UIView` instances
    /// - Returns: None
    func subviews(forAutoLayout subviews: [UIView]) {
        subviews.forEach(self.subview)
    }
    
}
