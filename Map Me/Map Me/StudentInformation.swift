//
//  ParseStudent.swift
//  Map Me
//
//  Created by Grant Kemp on 6/17/15.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation

struct StudentInformation {
    var createdAt: String = ""
    var firstName = ""
    var lastName = ""
    var latitude: Float
    var longitude: Float
    var mapString = ""
    var mediaURL = ""
    var objectId = ""
    var uniqueKey: String = ""
    var updatedAt = ""

    //Computed
    var fullname:String {
        get {
            return "\(firstName) \(lastName)"
        }
    }
    
    init(student: [String: AnyObject]) {
        self.createdAt = student["createdAt"] as! String
        self.firstName = student["firstName"] as! String
        self.lastName = student["lastName"] as! String
        self.latitude = student["latitude"] as! Float
        self.longitude = student["longitude"] as! Float
        self.mapString = student["mapString"] as! String
        self.mediaURL = student["mediaURL"] as! String
        self.objectId = student["objectId"] as! String
        self.uniqueKey = student["uniqueKey"] as! String
        self.updatedAt = student["updatedAt"] as! String
        
    }
    init(studentDetails: [String:AnyObject]) {
        self.firstName = studentDetails["firstname"] as! String
        self.lastName = studentDetails["lastname"] as! String
        self.uniqueKey = studentDetails["userId"] as! String
        self.mapString = studentDetails["MapString"] as! String
        self.mediaURL = studentDetails["MediaUrl"] as! String
        self.longitude = studentDetails["longitude"] as! Float
        self.latitude = studentDetails["latitude"] as! Float
    }
    
 
    static func StudentsFromResults(results: [[String:AnyObject]]) -> [StudentInformation]? {
        var parseStudents = [StudentInformation]()
        for student in results {
            
            var newStudent = StudentInformation(student: student)
            parseStudents.append(newStudent)
        }
        
    return parseStudents
    }
}

