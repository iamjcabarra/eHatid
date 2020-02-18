//
//  DeliveryRequest.swift
//  eHatid
//
//  Created by Julius Abarra on 2/14/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import Foundation
import Moya

// MARK: - Enumerator
public enum DeliveryRequest {
    case getDeliveries(offset: Int, limit: Int)
}

// MARK: - Moya TargetType Implementation
extension DeliveryRequest: TargetType {
    
    public var baseURL: URL {
        return Configuration().environment.baseUrl
    }
    
    public var path: String {
        switch self {
        case .getDeliveries:
            return "/v2/deliveries"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getDeliveries:
            return Moya.Method.get
        }
    }
    
    public var task: Task {
        switch self {
        case .getDeliveries(let offset, let limit):
            return .requestParameters(
                parameters: ["offset": offset, "limit": limit],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
}
