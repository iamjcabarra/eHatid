//
//  Delivery.swift
//  eHatid
//
//  Created by Julius Abarra on 2/14/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import Foundation

public final class Delivery: Decodable {
    
    // MARK: - Stored Properties
    public var id: String
    public var remarks: String
    public var pickupTime: String
    public var goodsPicture: String
    public var deliveryFee: String
    public var surcharge: String
    public var route: DeliveryRoute
    public var sender: DeliverySender
    
    // MARK: - Initializer
    public required init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Delivery.CodingKeys> = try decoder.container(
            keyedBy: Delivery.CodingKeys.self
        )
        
        self.id = try container.decode(String.self, forKey: Delivery.CodingKeys.id)
        self.remarks = try container.decode(String.self, forKey: Delivery.CodingKeys.remarks)
        self.pickupTime = try container.decode(String.self, forKey: Delivery.CodingKeys.pickupTime)
        self.goodsPicture = try container.decode(String.self, forKey: Delivery.CodingKeys.goodsPicture)
        self.deliveryFee = try container.decode(String.self, forKey: Delivery.CodingKeys.deliveryFee)
        self.surcharge = try container.decode(String.self, forKey: Delivery.CodingKeys.surcharge)
        self.route = try container.decode(DeliveryRoute.self, forKey: Delivery.CodingKeys.route)
        self.sender = try container.decode(DeliverySender.self, forKey: Delivery.CodingKeys.sender)
    }
    
    // MARK: - Enumerator
    public enum CodingKeys: String, CodingKey {
        case id
        case remarks
        case pickupTime
        case goodsPicture
        case deliveryFee
        case surcharge
        case route
        case sender
    }
    
}

// MARK: - Public APIs
extension Delivery {
    
    /// Computes for total fee by summing up the delivery fee and surcharge.
    /// Why not use `double` or `float` to represent currency?
    /// Reference: https://stackoverflow.com/questions/3730019/why-not-use-double-or-float-to-represent-currency
    public var totalFee: NSDecimalNumber {
        let deliveryFee: Decimal = self.deliveryFee.toDecimal()
        let surcharge: Decimal = self.surcharge.toDecimal()
        return NSDecimalNumber(decimal: deliveryFee + surcharge)
    }
    
}
