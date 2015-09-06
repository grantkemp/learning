//
//  Photo.swift
//  VirtualTourist
//
//  Created by Grant Kemp on 05/09/2015.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation
import CoreData

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
        
        if let photoUrlToUse  = NSURL(string: self.photoUrl) {
            
        var imageData = NSData(contentsOfURL: photoUrlToUse)
        
        let paths = FlickrConfig.paths
        //Create Path to Save
        var savePath = ""
        var imagePathToShow = ""
        if paths.count > 0 {
            
           
            let fileStoragePath = "/filename\(photoUrlToUse.lastPathComponent!)"
            savePath = documentsDirectory + fileStoragePath
            
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
    }

    func deletefileFromLocal() {
        var error: NSError?
        NSFileManager.defaultManager().removeItemAtPath(self.cacheddUrl, error: &error)
        println(error)
    }
    
    func getCachedPath() -> String {
        var urlToReturn: String = documentsDirectory + cacheddUrl
        return urlToReturn
    }
}