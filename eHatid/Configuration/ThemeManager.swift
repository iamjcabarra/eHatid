//
//  ThemeManager.swift
//  eHatid
//
//  Created by Julius Abarra on 2/14/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import Foundation
import UIKit

public class ThemeManager {
    
    /// Returns the persisted theme from user defaults if it exists; otherwise, it returns the first theme.
    ///
    /// - Parameters: None
    /// - Returns: None
    public static func currentTheme() -> Theme {
        guard
            let storedTheme = UserDefaults.standard.value(forKey: Constants.UserDefaultKey.theme) as? Int,
            let theme = Theme(rawValue: storedTheme)
        else {
            logger.error("Can't retrieve theme from user defaults.")
            return .theme1
        }
        
        return theme
    }

    /// Persists the selected theme using `NSUserDefaults` and applies it to the application's main
    /// window.
    ///
    /// - Parameter theme: A case of Theme
    /// - Returns: None
    public static func applyTheme(theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: Constants.UserDefaultKey.theme)
        UserDefaults.standard.synchronize()
        UINavigationBar.appearance().barTintColor = theme.navigationBarTintColor
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
}
