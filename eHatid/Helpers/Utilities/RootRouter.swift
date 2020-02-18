//
//  RootRouter.swift
//  eHatid
//
//  Created by Julius Abarra on 2/12/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import UIKit

public final class RootRouter {
    
    // MARK: - Utility Methods
    /// Sets view controller as the root view controller of the app's main window.
    ///
    /// - Parameters:
    ///     - controller: An instance of `UIViewController`
    ///     - animatedWithOptions: An animation for transition
    /// - Returns: None
    private func setRootViewController(controller: UIViewController, animatedWithOptions: UIView.AnimationOptions?) {
        guard let window = UIApplication.shared.keyWindow else {
            fatalError("There's no window in app.")
        }
        
        if let animationOptions = animatedWithOptions, window.rootViewController != nil {
            window.rootViewController = controller
            UIView.transition(with: window, duration: 0.3, options: animationOptions, animations: {}, completion: nil)
        } else {
            window.rootViewController = controller
        }
    }
    
}

// MARK: - Public APIs
extension RootRouter {
    
    /// Sets `DeliveryViewController` as the root view controller of the app's main window.
    ///
    /// - Parameters: None
    /// - Returns: None
    public func loadMainVC() {
        let controller: DeliveryVC = DeliveryVC(viewModel: DeliveryViewModel())
        let navigationController: UINavigationController = UINavigationController(rootViewController: controller)
        self.setRootViewController(controller: navigationController, animatedWithOptions: nil)
    }
    
}
