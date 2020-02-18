//
//  Theme.swift
//  eHatid
//
//  Created by Julius Abarra on 2/14/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import Foundation
import UIKit

/// App's UI theme cases
public enum Theme: Int {
    case theme1
    case theme2
}

// MARK: - Public APIs
extension Theme {
    
    /// Customizes the navigation bar color.
    public var navigationBarTintColor: UIColor {
        switch self {
        case .theme1:
            return UIColor().color(fromHexString: Constants.ColorHex.emerald)
        case .theme2:
            return UIColor().color(fromHexString: Constants.ColorHex.black)
        }
    }

    /// Customizer UI component's background color.
    public var backgroundColor: UIColor {
        switch self {
        case .theme1:
            return UIColor().color(fromHexString: Constants.ColorHex.whiteSmoke)
        case .theme2:
            return UIColor().color(fromHexString: Constants.ColorHex.creamBrulee)
        }
    }
    
    /// Customizes background color of primary text.
    public var titleTextBackgroundColor: UIColor {
        switch self {
        case .theme1:
            return UIColor().color(fromHexString: Constants.ColorHex.gossip)
        case .theme2:
            return UIColor().color(fromHexString: Constants.ColorHex.creamBrulee)
        }
    }
    
    /// Customizes color of primary text.
    public var titleTextColor: UIColor {
        switch self {
        case .theme1:
            return UIColor().color(fromHexString: Constants.ColorHex.black)
        case .theme2:
            return UIColor().color(fromHexString: Constants.ColorHex.black)
        }
    }
    
    /// Customizes color of secondary text.
    public var subtitleTextColor: UIColor {
        switch self {
        case .theme1:
            return UIColor().color(fromHexString: Constants.ColorHex.charcoal)
        case .theme2:
            return UIColor().color(fromHexString: Constants.ColorHex.charcoal)
        }
    }
    
    /// Customizes font of primary text.
    public var titleTextFont: UIFont {
        switch self {
        case .theme1:
            return UIFont(name: Constants.FontName.bold, size: 16.0) ??
                UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.bold)
        case .theme2:
            return UIFont(name: Constants.FontName.bold, size: 16.0) ??
                UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.bold)
        }
    }
    
    /// Customizes font of secondary text.
    public var subtitleTextFont: UIFont {
        switch self {
        case .theme1:
            return UIFont(name: Constants.FontName.regular, size: 13.0) ??
                UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.regular)
        case .theme2:
            return UIFont(name: Constants.FontName.regular, size: 13.0) ??
                UIFont.systemFont(ofSize: 13.0, weight: UIFont.Weight.regular)
        }
    }
    
}
