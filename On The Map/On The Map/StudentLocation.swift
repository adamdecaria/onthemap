//
//  StudentLocation.swift
//  On The Map
//
//  Created by Adam DeCaria on 2017-01-17.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    var createdAt : String
    var firstName : String
    var lastName : String
    var latitude : Double
    var longitude : Double
    var mapString : String
    var mediaURL : String
    var objectID : String
    var uniqueKey : String
    var updatedAt : String
    
    
    init?(studentDictionary: [String : AnyObject]) {
        
        // ensure there are corresponding values to each key
        guard
            let createdAt = studentDictionary["createdAt"] as? String,
            let firstName = studentDictionary["firstName"] as? String,
            let lastName = studentDictionary["lastName"] as? String,
            let latitude = studentDictionary["latitude"] as? Double,
            let longitude = studentDictionary["longitude"] as? Double,
            let mapString = studentDictionary["mapString"] as? String,
            let mediaURL = studentDictionary["mediaURL"] as? String,
            let objectID = studentDictionary["objectId"] as? String,
            let uniqueKey = studentDictionary["uniqueKey"] as? String,
            let updatedAt = studentDictionary["updatedAt"] as? String
        
            else { return nil } // return nil if object cannot be created
        
        // create object if all keys have values
        self.createdAt = createdAt
        self.firstName = firstName
        self.lastName  = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.objectID = objectID
        self.uniqueKey = uniqueKey
        self.updatedAt = updatedAt
    } // End init
    
} // End StudentLocation
