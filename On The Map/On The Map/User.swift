//
//  User.swift
//  On The Map
//
//  Created by Adam DeCaria on 2017-03-10.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import Foundation


// A class to represent the "user" of the app; includes info such as uniqueKey, firstName, lastName
class User : NSObject {
    
    var uniqueKey = ""
    var firstName = ""
    var lastName = ""
    
    var latitude = 0.0
    var longitude = 0.0
    
    var webAddress = "http://"
    
    // Singleton pattern used so the User is available across the app
    class func sharedUser() -> User {
        
        struct Singleton {
            static var sharedUser = User()
        }
        
        return Singleton.sharedUser
    }
    
} // End User

