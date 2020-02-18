//
//  String+Extension.swift
//  eHatid
//
//  Created by Julius Camba Abarra on 2/16/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import Foundation

extension String {
    
    /// Converts `String` value to `Decimal`.
    ///
    /// - Parameter locale: An identifier for currency; default is dollar.
    public func toDecimal(locale: Locale = Locale(identifier: "en_US")) -> Decimal {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = locale
        
        guard let number = formatter.number(from: self) else {
            logger.error("Can't convert \"\(self)\" to number.")
            return 0
        }
        
        /// Why not use `double` or `float` to represent currency?
        /// Reference: https://stackoverflow.com/questions/3730019/why-not-use-double-or-float-to-represent-currency
        return number.decimalValue
    }
    
}
