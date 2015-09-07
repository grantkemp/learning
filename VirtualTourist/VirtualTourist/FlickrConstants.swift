//
//  FlickrConstants.swift
//  VirtualTourist
//
//  Created by Grant Kemp on 23/08/2015.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation

extension FlickrClient {
//    static var exampleUrl (authenticated)= "https://api.flickr.com/services/rest/?method=&api_key=7c8b0e2c145b8ca7d4e97749a3aa9cb8&lat=51.508039&lon=-0.128069&per_page=15&format=json&nojsoncallback=1&auth_token=72157657208515910-529f88f28efa2417&api_sig=0337a444e6cfcb88a324241848963977"
//  static var example url simplified URL: https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=7c8b0e2c145b8ca7d4e97749a3aa9cb8&lat=51.508039&lon=-0.128069&per_page=15&format=json&nojsoncallback=1
    struct Methods {
        static let baseUrl = "https://api.flickr.com/services/rest/?method="
        static let search = "flickr.photos.search"
        
    }
    struct ParameterKeys {
        static let method = "method"
        static let api_key = "api_key"
        static let longitude = "lon"
        static let latitude = "lat"
        static let per_page = "per_page"
        static let format = "format"
        static let nojsoncallback = "nojsoncallback"
    }
    struct RequestJsonKeys {
    static let state = "not Used"
    }
    
    struct ResponseJsonKeys {
    static let a_photos = "photos"
    static let page = "page"
    static let b_photo_array = "photo"
    static let id = "id"
    }
}