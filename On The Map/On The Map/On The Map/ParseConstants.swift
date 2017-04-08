//
//  ParseConstants.swift
//  On The Map
//
//  Created by Adam DeCaria on 2017-01-17.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import Foundation

// ParseConstants
extension ParseClient {
    
    struct ParseConstants {
        // parse web API URL
        static let parseWebAddress : String = "https://parse.udacity.com/parse/classes/StudentLocation"
        static let jsonOK : String = "application/json"
    }
    
    struct ParseAPIRequired {
        
        // Parse application ID
        static let parseApplicationID : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // Parse REST API key
        static let parseAPIKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
} // End ParseConstants
