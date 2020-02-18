//
//  main.swift
//  eHatid
//
//  Created by Julius Abarra on 2/12/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import UIKit

/// Load the actual app with the right app delegate depending on the environment. Real app delegate
/// should not be used in testing since it may have side effects such as, making API calls, setting local
/// persistence, setting user interface, etc.
///
/// Reference: https://marcosantadev.com/fake-appdelegate-unit-testing-swift
///
let isInTestEnvironment: Bool = NSClassFromString("XCTestCase") != nil
let testAppDelegate: String = NSStringFromClass(TestAppDelegate.self)
let mainAppDelegate: String = NSStringFromClass(MainAppDelegate.self)
let appDelegateClassName: String = isInTestEnvironment ? testAppDelegate : mainAppDelegate
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, appDelegateClassName)
