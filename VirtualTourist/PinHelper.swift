//
//  PinHelper.swift
//  VirtualTourist
//
//  Created by Grant Kemp on 05/09/2015.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation
import MapKit
import CoreData


class PinHelper: NSObject {
    
    var mapManager = MapHelper()
    
    
    var pinsCD = [Pin]()
    
    func addPinToMap(mapview: MKMapView, location:CLLocationCoordinate2D) {
        
        
        let newPinView = Pin(llat: location.latitude, llong: location.longitude, llinksToImages: nil, context: sharedContext)
        
        var error: NSError?
        
        sharedContext.save(&error)
        
        if let uw_error = error {
            println("error saving context: \(uw_error)")
        }

        pinsCD.append(newPinView)
        mapview.addAnnotation(mapManager.createMapAnnotation(location,pinReference: newPinView.objectID))
        
        
        
        
    }
    func removePinFromMap(mapview: MKMapView,pinView: MKAnnotationView) {
        let annotationToRemove = pinView.annotation
        mapview.removeAnnotation(annotationToRemove)
        findMatchingPinInCollcetion(pinsCD, AnnotationIDToMatch: annotationToRemove) { (matchedPin, error) -> Void in
            if let uw_error = error {
            }
            else
            {
                self.sharedContext.deleteObject(matchedPin!)
                self.saveContext()
            }
        }
               
    }
    
    func addStoredPinsToMap(mp_mapview : MKMapView) {
        let error: NSErrorPointer = nil
        
        // Create the Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        fetchRequest.returnsObjectsAsFaults = false
        // Execute the Fetch Request
        let results = sharedContext.executeFetchRequest(fetchRequest, error: error) as! [Pin]
        
        // Check for Errors
        if error != nil {
            println("Error in fetchAllEvents(): \(error)")
        }
        for pinItem in results {
            pinsCD.append(pinItem)
        }
        
        mapManager.addPinsToMap(mp_mapview, listOfPins: pinsCD)
       
    }
    
    func findMatchingPinInCollcetion(pincollection: [Pin], AnnotationIDToMatch: MKAnnotation, completionHandler: (matchedPin: Pin?, error: String?)-> Void) {
        for pinItem in pinsCD {
            let pinID = AnnotationIDToMatch.title
            var idToCompare = "\(pinItem.objectID)"
            if idToCompare == pinID {
                completionHandler(matchedPin: pinItem, error: nil)
            }
            else {
                //TODO: Add proper NSError
                completionHandler(matchedPin: nil, error: "No Match")
            }
        }
    }
    
    
    //MARK: CoreData
    lazy var sharedContext: NSManagedObjectContext =  {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
        }()
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
    // MARK: - Shared Instance
    
    class func sharedInstance() -> PinHelper {
        
        struct Singleton {
            static var sharedInstance = PinHelper()
        }
        
        return Singleton.sharedInstance
    }


}