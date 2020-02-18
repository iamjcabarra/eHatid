//
//  DeliveryRoute.swift
//  eHatid
//
//  Created by Julius Abarra on 2/14/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import Foundation

public final class DeliveryRoute: Decodable {
    
    // MARK: - Stored Properties
    public var start: String
    public var end: String
    
    // MARK: - Initializer
    public required init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<DeliveryRoute.CodingKeys> = try decoder.container(
            keyedBy: DeliveryRoute.CodingKeys.self
        )
        
        self.start = try container.decode(String.self, forKey: DeliveryRoute.CodingKeys.start)
        self.end = try container.decode(String.self, forKey: DeliveryRoute.CodingKeys.end)
    }
    
    // MARK: - Enumerator
    public enum CodingKeys: String, CodingKey {
        case start
        case end
    }
    
}
