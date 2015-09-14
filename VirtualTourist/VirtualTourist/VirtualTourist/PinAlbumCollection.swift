//
//  PinAlbumCollection.swift
//  VirtualTourist
//
//  Created by Grant Kemp on 29/08/2015.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation
import MapKit

class PinAlbumCollection:NSObject {
    
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
    
    //MARK: Helpers
    
    func getNewReference() -> Int {
        
        var highestRef = 0
        if collection.count == 0 {
            return 1
        }
        else {
            var keys = collection.keys.array
            sort(&keys, >)
            highestRef = (keys.last)!
        }
        
        return highestRef + 1
    }
    
    func lookupReference(lat: CLLocationDegrees, long: CLLocationDegrees) -> Int {
        var reference:Int = -1
        for (key, album) in self.collection {
            if album.lat == lat {
                if album.long == long {
                    reference = album.reference
                }
            }
        }
        return reference
    }

}