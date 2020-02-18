//
//  NSDecimalNumber+Extension.swift
//  eHatid
//
//  Created by Julius Camba Abarra on 2/16/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import Foundation

extension NSDecimalNumber {
    
    /// Converts `Decimal` value to `String` of currency.
    ///
    /// - Parameter locale: An identifier for currency; default is dollar.
    public func toCurrency(locale: Locale = Locale(identifier: "en_US")) -> String {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = locale
        
        guard let currency = formatter.string(from: self) else {
            logger.error("Can't convert \"\(self)\" to currency.")
            return ""
        }
        
        return currency
    }
    
}
