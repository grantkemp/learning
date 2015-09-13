//
//  FickrClient.swift
//  VirtualTourist
//
//  Created by Grant Kemp on 22/08/2015.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation
import UIKit
import MapKit



class FlickrClient:NSObject {
    /* Shared Session */
    var session: NSURLSession
    
    /*Config Object */
    var config = FlickrConfig()
    //Method Variables
    //Helper Functions
    var photoManager = PhotoHelper()

    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    //Mark: Get Method
    func taskForGetMethod(methodToUse: String, parameters: [String: AnyObject], completionHandler: (result:AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
        
        /* 1. Set the parameters */
        var mutableParamaters = parameters
        if FlickrConfig.inDebugMode {
            mutableParamaters[FlickrClient.ParameterKeys.latitude] = FlickrConfig.debug_lat
            mutableParamaters[FlickrClient.ParameterKeys.longitude] = FlickrConfig.debug_long
        }
        else {
            mutableParamaters = parameters
        }
        mutableParamaters[FlickrClient.ParameterKeys.api_key] = FlickrConfig.apikey
        mutableParamaters[FlickrClient.ParameterKeys.format] = "json"
        mutableParamaters[FlickrClient.ParameterKeys.nojsoncallback] = 1
      
        
        /* 2/3. Build the URL and configure the request */
        let urlString = FlickrClient.Methods.baseUrl + methodToUse + FlickrClient.escapedParameters(mutableParamaters)
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        
        //Make the Request
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if let downloadError = error {
                println("there was an error downloading")
                println(error)
                completionHandler(result: nil, error: error)
            }
            
            else {
                //ParseData And Store
               FlickrClient.parseJSONWithCompletionhandler(data, completionHandler: { (result, error) -> Void in
                if let parsingError = error  {
                    println("error parsing Downloaded Data")
                    
                }
                else {
                    //Cache that we have downloaded images for this pin
                completionHandler(result: result, error: nil)
                }
               })
            }
            
            
        })
        task.resume()
        
        return NSURLSessionDataTask()
    }
    
    
    //MARK: - Helper Function
  /* Helps to process url params into right format */

    class func escapedParameters(parameters: [String:AnyObject]) -> String {
        //Convert params to right format for merging into url
        var urlVariables = [String]()
        for (key, value) in parameters {
            //Convert to String
            let stringValue = "\(value)"
            
            //Escape it 
            let escapedValue  = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            //break it out into one line
            urlVariables += [key + "=" + "\(escapedValue!)"]
        }
        return "&" + join("&", urlVariables)
    }

    class func parseJSONWithCompletionhandler(data: NSData, completionHandler: (photoUrls: [String]!, error: NSError?) -> Void) {
        
        var parsingError: NSError? = nil
        let parsedResult: AnyObject? =  NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
        
        if let parseError = parsingError {
            println("error parsing result")
            completionHandler(photoUrls: nil, error: parseError )
        }
        else {
            //Get the photos dictionary
            if let photosArray = parsedResult?.valueForKey("photos") {
                
              
               // Lets see how many photos there are
                var totalPhotos = (photosArray["total"] as! String).toInt()
                
                if totalPhotos > 0 {
                    // save photos to local docs
                    if let photos = photosArray.valueForKey("photo") {
                        //Parse out the urls for the photos
                        var photoUrls = Pin.photoUrlsFromResults(photos as! [[String : AnyObject]])
                        completionHandler(photoUrls: photoUrls, error: nil)
                    }

                }
                else {
                    //no photos show an error
                    //todo: Generate error for no photos
                    completionHandler(photoUrls: nil, error: nil)
                }

                
            }
            
        }
        
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> FlickrClient {
        
        struct Singleton {
            static var sharedInstance = FlickrClient()
        }
        
        return Singleton.sharedInstance
}
}

