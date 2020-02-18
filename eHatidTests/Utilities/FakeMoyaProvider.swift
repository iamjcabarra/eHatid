//
//  FakeMoyaProvider.swift
//  eHatidTests
//
//  Created by Julius Abarra on 2/18/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import Moya

public class FakeMoyaProvider<Target: TargetType> {
    
    // MARK: - Stored Propertiex
    public lazy var statusCode: Int = 200
    public var mockData: Data?
    public var targetReceived: TargetType?
    
    /// Creates a fake Moya Provider.
    ///
    /// - Parameters:
    ///     - response: An `Int` identifying response's code
    ///     - stubBehavior: A case of `StubBehavior`
    /// - Returns: An instance of `MoyaProvider` with a generic `Target`
    public func getProvider(
        response: Int = 200,
        stubBehavior: StubBehavior = StubBehavior.delayed(seconds: 0.1)
    ) -> MoyaProvider<Target> {
        self.statusCode = response

        let endpointClosure = { (target: Target) -> Endpoint in
            let url: String = target.baseURL.appendingPathComponent(target.path).absoluteString
            self.mockData = self.mockData ?? target.sampleData
            
            return Endpoint(
                url: url,
                sampleResponseClosure: {EndpointSampleResponse.networkResponse(self.statusCode, self.mockData!)},
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
        }
        
        return MoyaProvider<Target>(
            endpointClosure: endpointClosure,
            stubClosure: { (target: Target) -> Moya.StubBehavior in
                self.targetReceived = target
                return stubBehavior
        })
    }
    
}
