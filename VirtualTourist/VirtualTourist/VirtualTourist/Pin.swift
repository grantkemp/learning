//
//  PicturePin.swift
//  VirtualTourist
//
//  Created by Grant Kemp on 22/08/2015.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation
import MapKit
import CoreData

@objc(Pin)

class Pin : NSManagedObject {
    struct Keys {
        static let lat = "lat"
        static let long = "long"
        static let id   = "id"
    }
   
    @NSManaged var lat: Double
    @NSManaged var long: Double
    @NSManaged var reference: Int
    @NSManaged var numberDeleted:Int
    @NSManaged var attachedPhotos: NSSet
    @NSManaged var storeLocationName: PinCollection
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(llat: CLLocationDegrees, llong: CLLocationDegrees, llinksToImages: [String]?, context: NSManagedObjectContext) {
        
        let entity =  NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
        super.init(entity: entity,insertIntoManagedObjectContext: context)
        lat = llat as Double
        long = llong as Double
        reference = 1
        numberDeleted = 0
        storeLocationName = PinHelper.sharedInstance().cdPinCollection!
        
    }

    
    //MARK: ID Method
    
    func getId() -> NSManagedObjectID {
        return self.objectID
    }
    
    static func photoUrlsFromResults(photos: [[String:AnyObject]]) -> [String] {
        
        var photoUrls = [String]()
        
        for photo in photos {
        //get bits we need for url
        let farmId = photo["farm"] as! Int
        let serverID = photo["server"] as! String
        let photoID = photo["id"] as! String
        let photoSecret = photo["secret"] as! String
        
        //Build photo url
        let photoUrl = "https://farm\(farmId).staticflickr.com/\(serverID)/\(photoID)_\(photoSecret).jpg"
        photoUrls.append(photoUrl)
        }
        return photoUrls
        
      
    }
    func setReferenceForAlbum(ref: Int) {
        self.reference = ref
    }
    
    
   private func hasPhotosAttached() -> Bool{
    print(lat)
        if attachedPhotos.count > 0 {
            return true
        }
        else {
            return false
        }
    }
    
    func numberOfPhotosToDownload() -> Int {
        let hasAttachedphotos = self.hasPhotosAttached()
        if hasAttachedphotos {
            let numToDownload: Int = FlickrConfig.numToShowPerPage - self.attachedPhotos.count
            return numToDownload
        }
        else {
            return FlickrConfig.numToShowPerPage
        }
        
    }
    
    func deleteImages(photoToRemove: [Photo], context: NSManagedObjectContext, completionHandler:(complete: Bool, error: String?)-> Void) {
        self.numberDeleted += photoToRemove.count
        
        for photoItem in photoToRemove {
        context.deleteObject(photoItem)
        }
        CoreDataStackManager.sharedInstance().saveContext()
        completionHandler(complete: true, error: nil)
    }
    
    //MARK: Helper Methods
    
    func getNumberOfImagesTodownload() -> Int {
         return FlickrConfig.numToShowPerPage + numberDeleted
    }


}
