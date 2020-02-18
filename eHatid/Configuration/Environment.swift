//
//  Environment.swift
//  eHatid
//
//  Created by Julius Abarra on 2/13/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import Foundation

/// App's environment cases
public enum Environment {
    case development
    case staging
    case production
    
    private var apiProtocol: String {
        switch self {
        case .development:
            return "https"
        case .staging:
            return "https"
        case .production:
            return "https"
        }
    }
    
    private var apiHostname: String {
        switch self {
        case .development:
            return "mock-api-mobile.dev.lalamove.com"
        case .staging:
            return "mock-api-mobile.dev.lalamove.com"
        case .production:
            return "mock-api-mobile.dev.lalamove.com"
        }
    }
     
}

// MARK: - Public APIs
extension Environment {
    
    /// Gives base url of API server.
    public var baseUrl: URL {
        guard let url = URL(string: "\(self.apiProtocol)://\(self.apiHostname)") else {
            fatalError("API base url is nil.")
        }
        return url
    }
    
}
