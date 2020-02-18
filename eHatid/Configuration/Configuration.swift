//
//  Configuration.swift
//  eHatid
//
//  Created by Julius Abarra on 2/13/20.
//  Copyright © 2020 eXzeptional. All rights reserved.
//

import Foundation

public struct Configuration {
    
    /// Identifies the environment based on selected scheme.
    public var environment: Environment {
        #if DEV
            logger.info("Running in development environment.")
            return .development
        #elseif STA
            logger.info("Running in staging environment.")
            return .staging
        #elseif PRO
            logger.info("Running in production environment.")
            return .production
        #endif
    }
    
}
