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
    
    var studentList = [StudentLocation]()
    
    func taskForGETMethod(completionHandler: @escaping () -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: "\(ParseConstants.parseWebAddress)?limit=100&order=-updatedAt")!)
        
        request.httpMethod = "GET"
        request.addValue(ParseAPIRequired.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseAPIRequired.parseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue(ParseConstants.jsonOK, forHTTPHeaderField: "Accept")
        request.addValue(ParseConstants.jsonOK, forHTTPHeaderField: "Content-Type")
        
        
        let task = self.session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                print("Error with URL request")
                return
            }
            
            //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                    
                    guard let resultsArray = parsedResult["results"] as? [[String:AnyObject]] else {
                        print("Cannot find key 'results'")
                        return
                    }
                    
                    for element in resultsArray {
                        // check to make sure there is student data
                        if let student = StudentLocation(studentDictionary: element) {
                            self.studentList.append((student))
                        } else {
                            print("no student info")
                        }
                    }
                    
                } catch {
                    print("Error with the JSON data")
                }
            }
            
            DispatchQueue.main.async {
                completionHandler()
            }
        }
        task.resume()
    } // End taskForGETMethod
    /*
    func taskForPOSTSession(methodType: String, student: StudentLocation, completionHandler: @escaping (_ error: String?) -> Void) {
        
        let request = NSMutableURLRequest(url: URL(string: (ParseConstants.parseWebAddress + methodType))!)
        
        request.httpMethod = "POST"
        request.addValue(ParseConstants.jsonOK, forHTTPHeaderField: "Accept")
        request.addValue(ParseConstants.jsonOK, forHTTPHeaderField: "Content-Type")
       // request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: String.Encoding.utf8)
        
        
        
        
        
        /*
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
 */
    }
    */
    func shareStudentList() -> [StudentLocation] {
        return self.studentList
    } // End shareStudentList
    
    // Singleton pattern for a shared UdacityClient instance across the app
    class func sharedInstance() -> ParseClient {
        
        struct ParseSingleton {
            static var sharedParseInstance = ParseClient()
        }
        
        return ParseSingleton.sharedParseInstance
        
    } // End sharedInstance()
    
}// End ParseClient
