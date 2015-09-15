//
//  FlickrConfig.swift
//  VirtualTourist
//
//  Created by Grant Kemp on 22/08/2015.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation

class FlickrConfig: NSObject {
    
    static var authUrl = "https://www.flickr.com/auth-72157657554563956"
    static var apikey = "1448f15c8e6659546bcdfa900c6caec4"
    static var numToShowPerPage = 4
    static var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    static var nameOfCollection = "default"
    
    
    //debugmode
    static var debug_lat = 51.508039
    static var debug_long = -0.128069
    static var inDebugMode = false
// use this to automatically use debug lat Long

}