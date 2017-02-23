//
//  Constants.swift
//  On The Map
//
//  Created by Adam DeCaria on 2017-01-14.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import Foundation


// MARK: extension for Constants to be used with Udacity Web API
extension UdacityClient {
    
    // MARK: Udacity Web API address
    struct UdacityConstants {
        static let udacityWebAddress : String = "https://www.udacity.com/api/"
        static let jsonOK : String = "application/json"
        static let udacitySignupURL = "https://www.udacity.com/account/auth#!/signup"
    }
    
    // MARK: methods from the Udacity Web API
    struct Methods {
        static let session = "session"
    }
    
} // End Constants
 
