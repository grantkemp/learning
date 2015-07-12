//
//  ParseClient.swift
//  Map Me
//
//  Created by Grant Kemp on 6/17/15.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation

class  ParseClient: NSObject {
    
    //Shared Session
    var session: NSURLSession
    var usersObjectId = ""
    var studentGrouplist = StudentGroup()
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    //MARK: Rest Methods
    
    func taskforGETMethod(method: String, parameters: [String: AnyObject], completionHandler:(result: AnyObject!, error: NSError?)-> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2. Build the URL */
       let urlToUseString =  Constants.baseUrl + method
         let urlToUse = NSURL(string: urlToUseString)!
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: urlToUse)
        request.addValue(Constants.apiKey, forHTTPHeaderField: ResponseHeaderFields.appkey)
        request.addValue(Constants.restApiKey, forHTTPHeaderField: ResponseHeaderFields.restkey)
        /* 4. Make the request */
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
           
            if let downloadError = error {
                
                completionHandler(result: nil, error: error)
            }
            else {
                /* 6. Use the data! */
               // completionHandler(result: data, error: nil)
                ParseClient.parseJSONResultsWithCompletion(data, completionHandler: completionHandler)
            }
           
        })        /* 5. Parse the data */
        
        
        /* 7. Start the request */
        task.resume()
        return task
    }
    
    func taskforPOSTMethod(method: String, parameters: [String: AnyObject], jsonBody: [String: AnyObject],completionHandler:(result: AnyObject!, error: NSError?)-> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        
        /* 2. Build the URL */
        let urlToUseString =  Constants.baseUrl + method
        let urlToUse = NSURL(string: urlToUseString)!
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: urlToUse)
        request.HTTPMethod = "POST"
        request.addValue(Constants.apiKey, forHTTPHeaderField: ResponseHeaderFields.appkey)
        request.addValue(Constants.restApiKey, forHTTPHeaderField: ResponseHeaderFields.restkey)
        
        var jsonifyError:NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(jsonBody, options: nil, error: &jsonifyError)
        /* 4. Make the request */
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            if let downloadError = error {
                completionHandler(result: nil, error: error)
            }
            else {
                /* 6. Use the data! */
                ParseClient.parseJSONResultsWithCompletion(data, completionHandler: completionHandler)
            }
            
        })        /* 5. Parse the data */
        
        /* 7. Start the request */
        task.resume()
        return task
    }
     //MARK : Data Parsing

    
        /* Helper: Given raw JSON, return a usable Foundation object */
        class func parseJSONResultsWithCompletion(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
            var jSONError:NSError? = nil
            let parsedJson = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &jSONError ) as! [String:AnyObject]
            
            if let parsingError = jSONError  {
                completionHandler(result: nil, error: jSONError)
            }
            else {
                completionHandler(result: parsedJson, error: nil)
            }
            
        
        
        

        
    }
    
    
    //MARK: Shared Instance Singleton
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
        
    }
    
   
    
}
