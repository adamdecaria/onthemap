//
//  StudentData.swift
//  On The Map
//
//  Created by Adam DeCaria on 2017-03-27.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import Foundation

class StudentData {
    
    var studentArray = [StudentLocation]()
    
    private init() {}
    
    class func shareStudentData() -> StudentData {
        
        struct Singleton {
            static var studentData = StudentData()
        }
        
        return Singleton.studentData
    }
    
} // End StudentData
