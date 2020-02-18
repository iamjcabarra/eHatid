//
//  DeliverySender.swift
//  eHatid
//
//  Created by Julius Abarra on 2/14/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import Foundation

public final class DeliverySender: Decodable {
    
    // MARK: - Stored Properties
    public var phone: String
    public var name: String
    public var email: String
    
    // MARK: - Initializer
    public required init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<DeliverySender.CodingKeys> = try decoder.container(
            keyedBy: DeliverySender.CodingKeys.self
        )
        
        self.phone = try container.decode(String.self, forKey: DeliverySender.CodingKeys.phone)
        self.name = try container.decode(String.self, forKey: DeliverySender.CodingKeys.name)
        self.email = try container.decode(String.self, forKey: DeliverySender.CodingKeys.email)
    }
    
    // MARK: - Enumerator
    public enum CodingKeys: String, CodingKey {
        case phone
        case name
        case email
    }
    
}
