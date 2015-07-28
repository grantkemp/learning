//
//  ParseConstants.swift
//  Map Me
//
//  Created by Grant Kemp on 6/17/15.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.

//


extension ParseClient {
    
    //MARK: Constants
    struct Constants {
        static let apiKey: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let restApiKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    //Mark: URLS
        static let baseUrl = "https://api.parse.com"
       }
        
    struct Methods {
        
        // Mark: Methods
        static let getAllStudentLocations = "/1/classes/StudentLocation"
        static let getStudentLocation = "/1/classes/StudentLocation"
        static let postStudentLocation = "/1/classes/StudentLocation"
        static let putStudentLocation = "/1/classes/StudentLocation/{objectId}"
    }
        // Mark: UrlKeys
    struct URLKeys {
        static let objectID = "objectId"
    }
    
    struct ResponseHeaderFields {
        static let appkey = "X-Parse-Application-Id"
        static let restkey = "X-Parse-REST-API-Key"
    }
    
    struct JSONResponseKeys {
        
        //MARK: Students
        static let studentResults = "results"
        
    }
    struct JSONBodyKeys {
    static let createdAt: String = "createdAt"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let mapString = "mapString"
    static let mediaURL = "mediaURL"
    static let objectId = "objectId"
    static let uniqueKey = "uniqueKey"
    static let updatedAt = "updatedAt"
    }
    
    
}