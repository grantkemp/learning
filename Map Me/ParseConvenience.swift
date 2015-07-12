//
//  ParseConvenience.swift
//  Map Me
//
//  Created by Grant Kemp on 6/17/15.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension ParseClient {
    

    
    func getStudents(completionHandler:(success:Bool?, error: NSError?) -> Void) {
       
        //1. Specify parameters and Method 
        let method = Methods.getAllStudentLocations
        let param = [String:AnyObject]()
        //2. Make the request
        taskforGETMethod(method, parameters: param) { (jSONResult, error) -> Void in
            if let downloadError = error {
                completionHandler(success: false, error: downloadError)
            }
            else {
              
                var key1 = JSONResponseKeys.studentResults
                if let results = jSONResult.valueForKey(ParseClient.JSONResponseKeys.studentResults) as? [[String:AnyObject]] {
                    if  let students = StudentInformation.StudentsFromResults(results) {
                        ParseClient.sharedInstance().studentGrouplist.studentList = students
                        completionHandler(success: true, error: error)
                    }
                 
                }
        }
    }
}
    
    func addPinTofeed(student: StudentInformation, completionHandler:(resultingObjectID: String?, error: NSError?) -> Void){
        
            let param = [String:AnyObject]()
            let method = ParseClient.Methods.postStudentLocation
            let jsonBody : [String: AnyObject] = [
            JSONBodyKeys.uniqueKey: student.uniqueKey,
            JSONBodyKeys.firstName: student.firstName,
            JSONBodyKeys.lastName: student.lastName,
            JSONBodyKeys.mapString: student.mapString,
            JSONBodyKeys.mediaURL: student.mediaURL,
            JSONBodyKeys.longitude: student.longitude, // Number
            JSONBodyKeys.latitude: student.latitude //Number
        ]
       
        taskforPOSTMethod(method, parameters: param, jsonBody: jsonBody) { (result, error) -> Void in
            if let postingError = error {
                completionHandler(resultingObjectID: nil, error: postingError)
            }
            else
            {
                var parsingError: NSError?
                if let myResult = result as? [String:AnyObject]{
                    let savedId = myResult["objectId"] as! String
                     completionHandler(resultingObjectID: savedId , error: nil)
                }
                
            }
        
        }
        
    }
    
    func generateAnnotationsfor(students: [StudentInformation]) -> [MKPointAnnotation]? {
        var pointAnnotations = [MKPointAnnotation]()
        for student in students {
            let newPointAnnotation = self.createPointAnnotationFrom(student)
            pointAnnotations.append(newPointAnnotation)
        }
        return pointAnnotations
    }

    func createPointAnnotationFrom(student: StudentInformation) -> MKPointAnnotation{
        var annotation = MKPointAnnotation()
        let longCoord = Double(student.longitude) as CLLocationDegrees
        let latCoord = Double(student.latitude) as CLLocationDegrees
        let coordinate = CLLocationCoordinate2DMake(latCoord, longCoord)
        annotation.coordinate = coordinate
        annotation.title = "\(student.firstName) \(student.lastName), \(student.mapString)"
        annotation.subtitle = student.mediaURL
        
        return annotation
    }
    func parseResultIntoObjects(ldata: NSData) {
        var myResults = NSString(data: ldata,encoding: NSUTF8StringEncoding)
    }
}