//
//  DeliveryViewModelTest.swift
//  eHatidTests
//
//  Created by Julius Abarra on 2/18/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import Foundation
import Moya
import Nimble
import Quick
@testable import eHatid

class DeliveryViewModelTest: QuickSpec {
    
    // MARK: - Stored Properties
    var fakeMoyaProvider: FakeMoyaProvider<DeliveryRequest>!
    var viewModel: DeliveryViewModel!
    
    // MARK: - Instance Method
    override func spec() {
        beforeEach {
            self.fakeMoyaProvider = FakeMoyaProvider<DeliveryRequest>()
            self.viewModel = DeliveryViewModel(
                deliveryAPIService: APIService(provider: self.fakeMoyaProvider.getProvider()),
                database: CoreDataStack(name: "DataModel")
            )
        }
        
        describe("request for deliveries") {
            context("success") {
                it("should receive deliveries") {
                    var expectedResponse: Bool = false
                    var receivedError: Error!
                    
                    self.fakeMoyaProvider.mockData = Mock.deliverySuccess.response
                    self.viewModel.getDeliveries(offset: 1, limit: 5) { (result) in
                        switch result {
                        case .success(let isSuccess):
                            expectedResponse = isSuccess
                        case .failure(let error):
                            receivedError = error
                        }
                    }
                    
                    expect(expectedResponse).toEventually(beTrue())
                    expect(receivedError).toEventually(beNil())
                }
            }
            
            context("failure") {
                it("should not receive deliveries") {
                    var expectedResponse: Bool = false
                    var receivedError: Error!
                    
                    self.fakeMoyaProvider.mockData = Mock.deliveryFailure.response
                    self.viewModel.getDeliveries(offset: 1, limit: 5) { (result) in
                        switch result {
                        case .success(let isSuccess):
                            expectedResponse = isSuccess
                        case .failure(let error):
                            receivedError = error
                        }
                    }
                    
                    expect(expectedResponse).toEventually(beFalse())
                    expect(receivedError).toEventuallyNot(beNil())
                }
            }
        }
    }

}
