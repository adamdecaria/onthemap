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
    
    func taskForPOSTStudent(completionHandler: @escaping (_ error: String?) -> Void) {
        
        print("Starting taskForPOSTStudent")
        
        let request = NSMutableURLRequest(url: URL(string: (ParseConstants.parseWebAddress))!)
        
        request.httpMethod = "POST"
        request.addValue(ParseClient.ParseAPIRequired.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.ParseAPIRequired.parseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue(ParseConstants.jsonOK, forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \(User.sharedUser().uniqueKey), \"firstName\": \(User.sharedUser().firstName), \"lastName\": \(User.sharedUser().lastName),\"mapString\": \(User.sharedUser().mapString), \"mediaURL\": \(User.sharedUser().webAddress),\"latitude\": \(User.sharedUser().latitude), \"longitude\": \(User.sharedUser().longitude)}".data(using: String.Encoding.utf8)

        print(User.sharedUser().firstName, User.sharedUser().firstName, User.sharedUser().mapString, User.sharedUser().webAddress, User.sharedUser().latitude)
        
        let task = self.session.dataTask(with: request as URLRequest) { data, response, error in
            
            func errorHandler(_ error: String) {
                print(error)
                completionHandler(error)
            }
            
            guard (error == nil) else {
                errorHandler(error as! String)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                let errorString = (response as? HTTPURLResponse)?.statusCode.description
                print(errorString!)
                errorHandler("Bad response from the server.")
                return
            }
            
            let range = Range(uncheckedBounds: (5, data!.count))
            let scrubbedData = data?.subdata(in: range)
            
            var parsedResult : [String:AnyObject]!
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: scrubbedData!, options: .allowFragments) as! [String:AnyObject]
                    
                    let studentCreated = parsedResult["createdAt"] as! String
                    print(studentCreated)
                } catch {
                    print("Created Student")
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
        
        task.resume()
 
    } // End taskForPOSTStudent
    
    func taskForGETSession() {

        print("Starting taskForGETSession")
        
        let string = ParseConstants.parseWebAddress
        let request = NSMutableURLRequest(url: URL(string: ("\(ParseConstants.parseWebAddress)?where={\"uniqueKey\":\"\(User.sharedUser().uniqueKey)\"}"))!)
        
        request.addValue(ParseAPIRequired.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseAPIRequired.parseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue(ParseConstants.jsonOK, forHTTPHeaderField: "Accept")
        request.addValue(ParseConstants.jsonOK, forHTTPHeaderField: "Content-Type")
        

        let task = self.session.dataTask(with: request as URLRequest) { data, response, error in
            
            print("started task")
            
            func errorHandler(_ error: String) {
                print("there was an error: " + error)
            }
            
            guard (error == nil) else {
                errorHandler(error as! String)
                return
            }
            
            /* GUARD: Ensure a successful 2XX response was received */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                errorHandler("Bad response from the server.")
                return
            }
            
            /*
            let range = Range(uncheckedBounds: (5, data!.count))
            let scrubbedData = data?.subdata(in: range)
            */
            //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            
            var parsedResult : [String:AnyObject]!
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    
                    let userDictionary = parsedResult["results"] as! [String:AnyObject]
                    print(userDictionary)
                    User.sharedUser().firstName = userDictionary["firstName"] as! String
                    User.sharedUser().lastName = userDictionary["lastName"] as! String
                    
                } catch {
                    print("Error with the JSON data")
                }
            }
        }
        task.resume()
    } // End taskForGETSession

        
 
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
