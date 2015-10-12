//
//  PinAlbumCollection.swift
//  VirtualTourist
//
//  Created by Grant Kemp on 29/08/2015.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation
import MapKit
import CoreData

@objc(PinCollection)

class PinCollection:NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var attachedPins: NSSet //TODO: Check Could we use Set here since Swift 1.2?
    
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
    }
    
        init(createNew: Bool,  context: NSManagedObjectContext) { 
        let entity =  NSEntityDescription.entityForName("PinCollection", inManagedObjectContext: context)!
        super.init(entity: entity,insertIntoManagedObjectContext: context)
            if createNew {
                name = FlickrConfig.nameOfCollection
            }
        
        }
    
    
    func getAllPins() -> [Pin] {
        
        return attachedPins.allObjects as! [Pin]
    }
    
    
    
    //MARK: Old Helpers
    var collection = [Int:Pin]()
    
    func addAlbum(item: Pin) -> Int{
        let newRef = getNewReference()
        collection[newRef] = item
        item.setReferenceForAlbum(newRef)
        return newRef
    }
    
    func deleteAlbum(ref: Int) {
        collection.removeValueForKey(ref)
    }
    
    func updateAlbum(item: Pin, ref: Int) {
        collection[ref] = item
    }
    
    
    
    func getNewReference() -> Int {
        
        var highestRef = 0
        if collection.count == 0 {
            return 1
        }
        else {
            var keys = Array(collection.keys)
            keys.sortInPlace(>)
            highestRef = (keys.last)!
        }
        
        return highestRef + 1
    }
    
    func lookupReference(lat: CLLocationDegrees, long: CLLocationDegrees) -> Int {
        var reference:Int = -1
        for (_, album) in self.collection {
            if album.lat == lat {
                if album.long == long {
                    reference = album.reference
                }
            }
        }
        return reference
    }

}