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
        
        let request = NSMutableURLRequest(url: URL(string: "\(ParseConstants.parseWebAddress)?limit=100")!)
        
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
                    //print(parsedResult)
                    
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
                    
                    //self.parseDataFromGETMethod(topLevelDictionary: parsedResult)
                    
                } catch {
                    print("Error with the JSON data")
                }
            }
            
            DispatchQueue.main.async {
                completionHandler()
            }
        }
        task.resume()
    }
    /*
     func parseDataFromGETMethod(topLevelDictionary: NSDictionary) {
     
     guard let resultsArray = topLevelDictionary["results"] as? [[String:AnyObject]] else {
     print("Cannot find key 'results'")
     return
     }
     
     for element in resultsArray {
     let student = StudentLocation(studentDictionary: element)
     self.studentList.append(student)
     }
     print("Student list from parseDataFromGET is... \(self.studentList)")
     } // End parseDataFromGETMethod*/
    
    func shareStudentList() -> [StudentLocation] {
        print("Sharing this student list ... \(self.studentList)")
        return self.studentList
    }
    
}// End ParseClient
