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
    
    var studentArray = [StudentLocation]()
    
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
            
            //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            
            do {
                let parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                //print(parsedResult)
                
                let _ = self.parseDataFromGETMethod(topLevelDictionary: parsedResult)
            } catch {
                print("Error with the JSON data")
            }
        }
        task.resume()
    }
    
    func parseDataFromGETMethod(topLevelDictionary: NSDictionary) {
        
        guard let resultsArray = topLevelDictionary["results"] as? [[String:AnyObject]] else {
            print("Cannot find key 'results'")
            return
        }
        
        for element in resultsArray {
            var studentData = StudentLocation()
            studentData.createdAt = element["createdAt"] as! String
            studentData.lastName = element["lastName"] as! String
            studentData.firstName = element["firstName"] as! String
            studentData.latitude = element["latitude"] as! Double
            studentData.longitude = element["longitude"] as! Double
            studentData.mapString = element["mapString"] as! String
            studentData.mediaURL = element["mediaURL"] as! String
            studentData.objectID = element["objectId"] as! String
            studentData.updatedAt = element["updatedAt"] as! String
            studentData.uniqueKey = element["uniqueKey"] as! String
            
            studentArray.append(studentData)
            //print(studentArray)
        }
    } // End parseDataFromGETMethod
    
    func shareStudentData() -> [StudentLocation] {
        return studentArray
    } // End shareStudentData
    
} // End ParseClient
