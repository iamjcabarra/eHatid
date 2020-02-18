//
//  Mock.swift
//  eHatidTests
//
//  Created by Julius Abarra on 2/18/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import Foundation

public enum Mock {
    case deliverySuccess
    case deliveryFailure
    
    public var response: Data {
        var resource: String = ""
        
        switch self {
        case .deliverySuccess:
            resource = "DeliveriesSuccess"
        case .deliveryFailure:
            resource = "DeliveriesFailure"
        }

        guard
            let url = Bundle.main.url(forResource: resource, withExtension: "json"),
            let data = try? Data(contentsOf: url)
        else { return Data() }
        return data
    }
    
}
