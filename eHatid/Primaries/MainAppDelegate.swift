//
//  MainAppDelegate.swift
//  eHatid
//
//  Created by Julius Abarra on 2/12/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import netfox
import UIKit

internal class MainAppDelegate: UIResponder {
    
    // MARK: - Stored Properties
    internal var window: UIWindow?
    internal lazy var router = RootRouter()

}

// MARK: - UIApplicationDelegate Methods
extension MainAppDelegate: UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Configure logger
        logger.setup(level: .debug,
                     showThreadName: true,
                     showLevel: true,
                     showFileNames: true,
                     showLineNumbers: true,
                     writeToFile: nil,
                     fileLevel: .debug
        )
        
        // Initiate netfox for network debugging purposes
        #if DEV
        NFX.sharedInstance().start()
        #endif
        
        // Configure root window
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        // Congigure app theme
        ThemeManager.applyTheme(theme: .theme1)
        
        // Configure root view controller
        router.loadMainVC()
        
        return true
    }
    
}
