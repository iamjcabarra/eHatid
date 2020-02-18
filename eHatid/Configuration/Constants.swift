//
//  Constants.swift
//  eHatid
//
//  Created by Julius Camba Abarra on 2/15/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import Foundation

public struct Constants {
    
    /// Colors
    public struct ColorHex {
        public static let black: String = "000000"
        public static let charcoal: String = "444444"
        public static let creamBrulee: String = "FFE599"
        public static let emerald: String = "076B18"
        public static let gossip: String = "93C47D"
        public static let whiteSmoke: String = "F3F3F3"
    }
    
    /// Entities
    public struct Entity {
        public static let delivery: String = "LocalDelivery"
        public static let deliverySender: String = "LocalDeliverySender"
        public static let deliveryRoute: String = "LocalDeliveryRoute"
    }
    
    /// Fonts
    public struct FontName {
        public static let bold: String = "ProximaNovaBold"
        public static let regular: String = "ProximaNovaRegular"
    }
    
    /// Keys
    public struct UserDefaultKey {
        public static let theme: String = "SelectedThemeKey"
    }
        
}
