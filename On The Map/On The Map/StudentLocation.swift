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
    
    
    init(studentDictionary: [String : AnyObject]) {
        self.createdAt = studentDictionary["createdAt"] as! String
        self.firstName = studentDictionary["firstName"] as! String
        self.lastName  = studentDictionary["lastName"] as! String
        self.latitude = studentDictionary["latitude"] as! Double
        self.longitude = studentDictionary["longitude"] as! Double
        self.mapString = studentDictionary["mapString"] as! String
        self.mediaURL = studentDictionary["mediaURL"] as! String
        self.objectID = studentDictionary["objectId"] as! String
        self.uniqueKey = studentDictionary["uniqueKey"] as! String
        self.updatedAt = studentDictionary["updatedAt"] as! String
    }
    
} // End StudentLocation
