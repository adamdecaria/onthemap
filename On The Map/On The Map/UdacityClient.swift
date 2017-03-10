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
    
    func taskForPOSTSession(methodType: String, completionHandler: @escaping (_ error: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: (UdacityConstants.udacityWebAddress + methodType))!)
        
        request.httpMethod = "POST"
        request.addValue(UdacityConstants.jsonOK, forHTTPHeaderField: "Accept")
        request.addValue(UdacityConstants.jsonOK, forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(userEmail)\", \"password\": \"\(userPassword)\"}}".data(using: String.Encoding.utf8)

        let task = self.session.dataTask(with: request as URLRequest) { data, response, error in
            
            func errorHandler(_ error: String) {
                print(error)
                completionHandler(error)
            }
            
            guard (error == nil) else {
                errorHandler(error as! String)
                return
            }
            
            /* GUARD: Ensure a successful 2XX response was received */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                errorHandler("Bad response from the server.  Check username/password.")
                return
            }
            
            let range = Range(uncheckedBounds: (5, data!.count))
            let scrubbedData = data?.subdata(in: range)
                
            //print(NSString(data: scrubbedData!, encoding: String.Encoding.utf8.rawValue)!)
                
            var parsedResult : [String:AnyObject]!
            
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: scrubbedData!, options: .allowFragments) as! [String:AnyObject]
                    print(parsedResult.keys)
                    let sessionDictionary = parsedResult["session"]
                    self.sessionID = sessionDictionary?["id"] as! String
                } catch {
                    print("Error with the JSON data")
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
            
        }
        
        task.resume()
        
    } // End taskForPOSTSession
    
    func taskForPOSTDeleteSession(completionHandler: @escaping () -> Void) {
        
        var xsrfCookie: HTTPCookie? = nil
        
        let request = NSMutableURLRequest(url: URL(string: UdacityConstants.udacityWebAddress + Methods.session)!)
        request.httpMethod = "DELETE"
        request.addValue(UdacityConstants.jsonOK, forHTTPHeaderField: "Accept")
        request.addValue(UdacityConstants.jsonOK, forHTTPHeaderField: "Content-Type")
        
        // remove any cookies associated with Udacity API granted session
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                print("There was an error logging out.")
            }
            
            let range = Range(uncheckedBounds: (5, data!.count))
            let scrubbedData = data?.subdata(in: range)
            
            print(NSString(data: scrubbedData!, encoding: String.Encoding.utf8.rawValue)!)
            
            var parsedResult : [String:AnyObject]!
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: scrubbedData!, options: .allowFragments) as! [String:AnyObject]
                    let sessionDictionary = parsedResult["session"]
                    self.sessionID = sessionDictionary?["id"] as! String
                    
                    print("Logged out.")
                    
                } catch {
                    print("Error with the JSON data")
                }
            }
            
            DispatchQueue.main.async {
                completionHandler()
            }
        }
        
        task.resume()
        
    } // End taskForPOSTDeleteSession
    
    
    // Singleton pattern for a shared UdacityClient instance across the app
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
        
    } // End sharedInstance()
    
} // End UdacityClient
