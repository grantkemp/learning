//
//  FlickrConvenience.swift
//  VirtualTourist
//
//  Created by Grant Kemp on 23/08/2015.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation
import MapKit

extension FlickrClient {

    func GetFlickrPhotoUrls(pinItem: Pin, completionHandler: (resultPinAlbum: Bool?, error: NSError?) -> Void) {
        
        var numberImagesToAttachToPin = 0
       
        let sourcePinAlbum = pinItem

        numberImagesToAttachToPin = pinItem.numberOfPhotosToDownload()
        
        
        if numberImagesToAttachToPin == 0 {
            // Don't need to download any more as photos are  attached to Pin is 0
            completionHandler(resultPinAlbum: true , error: nil)
        }
        else {
            //Download Pins for Location
        
        var params = [String:AnyObject]()
        
        params[FlickrClient.ParameterKeys.latitude] = sourcePinAlbum.lat
        params[FlickrClient.ParameterKeys.longitude] = sourcePinAlbum.long
            
        params[FlickrClient.ParameterKeys.per_page] = sourcePinAlbum.getNumberOfImagesTodownload()

        FlickrClient.sharedInstance().taskForGetMethod(FlickrClient.Methods.search, parameters: params) { (result, error) -> Void in
            if let fetchError = error {
                println("unable to get Urls")
                completionHandler(resultPinAlbum: nil, error: fetchError)
            }
            else {
                if result == nil {
                    //No images to download
                    let noImagesError = NSError(domain: "domain", code: 99992, userInfo: [NSLocalizedDescriptionKey:"No images to download, please try a different location"])
                    completionHandler(resultPinAlbum: nil, error: noImagesError)
                }
                else
                {
               //create Array with photoUrl results
                    var photoUrls = result as! [String]
                    
                    var resultsArray = [String]()
                    if photoUrls.count == numberImagesToAttachToPin {
                        //got the right number of images to show:
                           self.photoManager.saveUrlsToPin(pinItem, urlsToStore: photoUrls)
                        completionHandler(resultPinAlbum: true, error: nil)
                    }
                    else if photoUrls.count > numberImagesToAttachToPin {
                        var startingPosition = photoUrls.count - numberImagesToAttachToPin
                        println(startingPosition)
                        for var i = startingPosition; i<photoUrls.count; ++i {
                            resultsArray.append(photoUrls[i])
                            
                        }
                        self.photoManager.saveUrlsToPin(pinItem, urlsToStore: resultsArray)
                        completionHandler(resultPinAlbum: true, error: nil)
                    }

                }
            }
            }
        }
        }
    
    
    }