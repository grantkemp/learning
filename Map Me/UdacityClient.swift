//
//  UdacityClient.swift
//  Map Me
//
//  Created by Grant Kemp on 6/21/15.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
    
    //Shared Session
    var session: NSURLSession
    
    //Config Object
    var config = UdacityConfig()
    
    //authentication Status
    var userID:String = ""
    var sessionID:String = ""

    //facebook
    var usedFacebook = false
    var userFacebookAccessToken = ""
    var userFacebookID = ""
    
    //Details for account
    var userFirstName: String = ""
    var userLastName: String = ""
    
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    func taskForPost(method: String, jsonBodyAsData: NSData, completionHandler: (result: NSData?, error: NSError?) ->Void) {
        let methodToUse = method
        
        let urlString = UdacityConfig.secureURL + method
        let url: NSURL = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonBodyAsData
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if let downloadError = error {
                completionHandler(result: nil, error: error)
            }
            else {
                let newData = data.subdataWithRange(NSMakeRange(5,data.length - 5))
                println(NSString(data: data!, encoding: NSUTF8StringEncoding))
                completionHandler(result: newData, error: nil)
            
            }
            
        })
        task.resume()
    }
    
    func taskForGet(lMethod: String, completionHandler: (result: NSData?, error: NSError?) -> Void) {
        let method = lMethod
        let methodWithId =   method.stringByReplacingOccurrencesOfString("{user_id}", withString: self.userID, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        let urlString = UdacityConfig.secureURL + methodWithId
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if let downloadError = error {
                completionHandler(result: nil, error: error)
            }
            else {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                completionHandler(result: newData, error: nil)
            }
        })
        task.resume()
    }
    
    
    func taskForDelete(method: String, completionHandler: (result: NSData?, error: NSError?) ->Void) {
        let methodToUse = method
        
        let urlString = UdacityConfig.secureURL + method
        let url: NSURL = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
          for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
           }
            if let xsrfCookie = xsrfCookie {
            request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
          }
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if let downloadError = error {
                completionHandler(result: nil, error: error)
            }
            else {
                let newData = data.subdataWithRange(NSMakeRange(5,data.length - 5))
                
                
                
                completionHandler(result: newData, error: nil)
                
            }
            
        })
        task.resume()
    }

    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
}


