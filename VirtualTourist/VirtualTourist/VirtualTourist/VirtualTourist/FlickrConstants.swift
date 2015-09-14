//
//  FlickrConstants.swift
//  VirtualTourist
//
//  Created by Grant Kemp on 23/08/2015.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation

extension FlickrClient {

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