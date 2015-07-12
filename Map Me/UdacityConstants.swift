//
//  UdacityConstants.swift
//  Map Me
//
//  Created by Grant Kemp on 6/21/15.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation

extension UdacityClient{
    struct Methods {
        static let apiSession = "/api/session"
        static let users = "/api/users/{user_id}"
    }
    
    struct ParameterKeys {
        static let username = "username"
        static let password = "password"
    }
    
    struct RequestJsonKeys {
        static let udacity = "udacity"
        static let username = "username"
        static let password = "password"
        static let facebook_mobile = "facebook_mobile"
        static let access_token = "access_token"
    }
    struct ResponseJsonKeys {
        static let status = "status"
        static let error = "error"
        //success Keys 
        static let session = "session"
        static let session_id = "id"
        
        //User Id Keys
        static let account = "account"
        static let account_key = "key"
        static let firstname = "first_name"
        static let lastname = "last_name"
        static let user = "user"
    }
}
