//
//  UdacityClient.swift
//  On The Map
//
//  Created by Adam DeCaria on 2017-01-11.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import Foundation

// MARK: UdacityClient : NSObject

class UdacityClient : NSObject {
    
    // MARK: Properties
    
    // shared URL session
    let session = URLSession.shared
    
    // session ID from Udacity API
    var sessionID = ""
    
    // login information submitted by user
    var userEmail: String = ""
    var userPassword: String = ""
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    func getLoginInfo(username: String, password: String) {
        userEmail = username
        userPassword = password
    }
    
    func taskForPOSTSession() {
        
        let request = NSMutableURLRequest(url: URL(string: (Constants.webAddress + Methods.session))!)
        
        request.httpMethod = "POST"
        request.addValue(Constants.jsonOK, forHTTPHeaderField: "Accept")
        request.addValue(Constants.jsonOK, forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(userEmail)\", \"password\": \"\(userPassword)\"}}".data(using: String.Encoding.utf8)

        print("Made Request")
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                print("There was an error getting a session.")
                return
            }

            let range = Range(uncheckedBounds: (5, data!.count))
            let scrubbedData = data?.subdata(in: range)

            print(NSString(data: scrubbedData!, encoding: String.Encoding.utf8.rawValue)!)

            let parsedResult : [String:AnyObject]!
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: scrubbedData!, options: .allowFragments) as! [String:AnyObject]
                let sessionDictionary = parsedResult["session"]
                self.sessionID = sessionDictionary?["id"] as! String
                print(self.sessionID)
            
            } catch {
                print("Error with the JSON data")
            }
            
        }
        task.resume()
        
    }
    
} // End UdacityClient
