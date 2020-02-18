//
//  DeliveryVCTest.swift
//  eHatidTests
//
//  Created by Julius Abarra on 2/18/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import Foundation
import Moya
import Nimble
import Quick
import UIKit
@testable import eHatid

class DeliveryVCTest: QuickSpec {

    // MARK: - Instance Method
    override func spec() {
        var fakeMoyaProvider: FakeMoyaProvider<DeliveryRequest>!
        var viewModel: DeliveryViewModel!
        var viewController: DeliveryVC!
        var navigationController: UINavigationController!
        var window: UIWindow!
        
        beforeEach {
            // Configure view controller injecting required dependecies
            fakeMoyaProvider = FakeMoyaProvider<DeliveryRequest>()
            viewModel = DeliveryViewModel(
                deliveryAPIService: APIService(provider: fakeMoyaProvider.getProvider()),
                database: CoreDataStack(name: "DataModel")
            )
            viewController = DeliveryVC(viewModel: viewModel)
            
            // For testing navigation behaviors
            navigationController = UINavigationController(rootViewController: viewController)
            window = UIWindow()
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            
            // Triggers .viewDidLoad(), .viewWillAppear(), and .viewDidAppear() events
            viewController.beginAppearanceTransition(true, animated: false)
            viewController.endAppearanceTransition()
        }
        
        // MARK: - Test View Life Cycle
        describe("when view loads") {
            it("configures primary view") {
                expect(viewController.view).notTo(beNil())
                let checkViewType = viewController.view is DeliveryView
                expect(checkViewType).to(beTrue())
            }
            
            it("configures table view") {
                expect(viewController.rootView.tableView.dataSource).toNot(beNil())
                expect(viewController.rootView.tableView.delegate).toNot(beNil())
            }
        }
    }
    
}
