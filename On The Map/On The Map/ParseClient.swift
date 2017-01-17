//
//  ParseClient.swift
//  On The Map
//
//  Created by Adam DeCaria on 2017-01-17.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import Foundation

// MARK: ParseClient : NSObject
class ParseClient : NSObject {
    
    // MARK: properties
    
    // shared URL session for this app
    let session = URLSession.shared
    
    func taskForGETMethod() {
        
        let request = NSMutableURLRequest(url: URL(string: "\(ParseConstants.parseWebAddress)?limit=10")!)
        
        request.httpMethod = "GET"
        request.addValue(ParseAPIRequired.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseAPIRequired.parseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue(ParseConstants.jsonOK, forHTTPHeaderField: "Accept")
        request.addValue(ParseConstants.jsonOK, forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                print("Error with URL request")
                return
            }
            
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            
            let parsedResult : [String:AnyObject]!
            
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                print(parsedResult)
            } catch {
                print("Error with the JSON data")
            }
        }
        task.resume()
    }
    
    
} // End ParseClient
