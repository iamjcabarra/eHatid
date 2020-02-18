//
//  APIService.swift
//  eHatid
//
//  Created by Julius Abarra on 2/12/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import Foundation
import Moya
import PromiseKit

public final class APIService<T: TargetType> {
    
    // MARK: - Stored Properties
    private var provider: MoyaProvider<T>
    
    // MARK: - Initializer
    public init(provider: MoyaProvider<T>) {
        self.provider = provider
    }
    
    // MARK: - Request Handlers
    /// Processes generic request which returns a promise of decoded API response or error.
    ///
    /// - Parameters:
    ///     - request: A generic request
    ///     - responseType: Expected decoded response
    /// - Returns: A promise of decoded API response or error
    public func request<U: Decodable>(_ request: T, responseType: U.Type) -> Promise<U> {
        return Promise<U> { promise in
            let method: String = request.method.rawValue.uppercased()
            let url: URL = request.baseURL.appendingPathComponent(request.path)
            logger.info("\(method)-\(url)")
            
            self.provider.request(request) { result -> Void in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try JSONDecoder().decode(U.self, from: response.data)
                        promise.fulfill(decodedResponse)
                    } catch let error {
                        promise.reject(error)
                    }
                case .failure(let error):
                    promise.reject(error)
                }
            }
        }
    }

}
