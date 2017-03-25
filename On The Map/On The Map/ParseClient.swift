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
    
    func taskForPOSTStudent() {
        
        print("Starting taskForPOSTStudent")
        print("Key: " + User.sharedUser().uniqueKey)
        print("First name: " + User.sharedUser().firstName)
        print("Last name: " + User.sharedUser().lastName)
        print("URL: " + User.sharedUser().webAddress)
        
        let request = NSMutableURLRequest(url: URL(string: (ParseConstants.parseWebAddress))!)
        
        request.httpMethod = "POST"
        request.addValue(ParseClient.ParseAPIRequired.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.ParseAPIRequired.parseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue(ParseConstants.jsonOK, forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(User.sharedUser().uniqueKey)\", \"firstName\": \"\(User.sharedUser().firstName)\", \"lastName\": \"\(User.sharedUser().lastName)\",\"mapString\": \"\(User.sharedUser().mapString)\", \"mediaURL\": \"\(User.sharedUser().webAddress)\",\"latitude\": \(User.sharedUser().latitude), \"longitude\": \(User.sharedUser().longitude)}".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))

        
        let task = self.session.dataTask(with: request as URLRequest) { data, response, error in
            
            func errorHandler(_ error: String) {
                print(error)
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

            
            var parsedResult : [String:AnyObject]!
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    
                    let studentCreated = parsedResult["createdAt"] as! String
                    print(studentCreated)
                } catch {
                    print("There was an error creating the student.")
                }
            }
        }
        
        task.resume()
 
    } // End taskForPOSTStudent
    
    func taskForGETSession(completionHandler: @escaping () -> Void) {

        print("Starting taskForGETSession")
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "parse.udacity.com"
        urlComponents.path = "/parse/classes/StudentLocation"
        urlComponents.queryItems = [URLQueryItem]()
        
        
        let queryItemOne = URLQueryItem(name: "where", value: "{\"uniqueKey\":\"\(User.sharedUser().uniqueKey)\"}")
        print(queryItemOne)
        
        urlComponents.queryItems?.append(queryItemOne)
        
        print(urlComponents.url!)

        let request = NSMutableURLRequest(url: urlComponents.url!)

        
        request.httpMethod = "GET"
        request.addValue(ParseAPIRequired.parseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseAPIRequired.parseAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
  
    
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
            
            var parsedResult : [String:AnyObject]!
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                    
                    let userArray = parsedResult["results"] as! [AnyObject]
                    let userDictionary = userArray[0]
                    
                    User.sharedUser().firstName = userDictionary["firstName"] as! String
                    User.sharedUser().lastName = userDictionary["lastName"] as! String
    
                } catch {
                    print("Error with the JSON data")
                }
                completionHandler()
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
