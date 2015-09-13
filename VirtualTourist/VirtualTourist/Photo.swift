//
//  Photo.swift
//  VirtualTourist
//
//  Created by Grant Kemp on 05/09/2015.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(Photo)

class Photo: NSManagedObject {
    @NSManaged var cacheddUrl: String
    @NSManaged var photoUrl: String
    @NSManaged var pinRef: Pin
    
    let documentsDirectory = FlickrConfig.paths[0] as! String
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(lphotoUrl: String, pinToUse: Pin, context: NSManagedObjectContext) {
        
        let entity =  NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        photoUrl = lphotoUrl
        pinRef = pinToUse
        
        //initialise a blank cacheddUrl
        cacheddUrl = ""
    }

    func updateLocalUrlWithCachedImage(localUrlforImage: String) {
    self.cacheddUrl = localUrlforImage
    }
    
    
    func downloadImageToLocalDisk(completionHandler: (localImagePath: String, error: String?) -> Void){
//        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -&gt; Void in
        
        if let photoUrlToUse  = NSURL(string: self.photoUrl) {
            let requestToUse = NSURLRequest(URL: photoUrlToUse)
            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(requestToUse, queue: mainQueue, completionHandler: { (response, returnedData, error) -> Void in
                if let uw_error = error {
                    println("there has been an error downloading the file")
                    
                }
                else {
                    let imageData = returnedData
                    //Download image Async
                    let paths = FlickrConfig.paths
                    //Create Path to Save
                    var savePath = ""
                    var imagePathToShow = ""
                    if paths.count > 0 {
                        
                        
                        let fileStoragePath = "/filename\(photoUrlToUse.lastPathComponent!)"
                        savePath = self.documentsDirectory + fileStoragePath
                        
                        //check if its already downloaded:
                        if NSFileManager.defaultManager().fileExistsAtPath(savePath) {
                            println("The file already exists!")
                            imagePathToShow = savePath
                        }
                        else {
                            // Save the file
                            NSFileManager.defaultManager().createFileAtPath(savePath, contents: imageData, attributes: nil)
                            imagePathToShow = savePath
                        }
                        self.cacheddUrl = fileStoragePath
                        CoreDataStackManager.sharedInstance().saveContext()
                    }
                    completionHandler(localImagePath: imagePathToShow, error: nil)
                }
            })
            
        
        }
    }

    func deletefileFromLocal() {
        var error: NSError?
        NSFileManager.defaultManager().removeItemAtPath(self.getCachedPath(), error: &error)
        println(error)
    }
    
    func getCachedPath() -> String {
        var urlToReturn: String = documentsDirectory + cacheddUrl
        return urlToReturn
    }
    override func prepareForDeletion() {
        self.deletefileFromLocal()
    }
}