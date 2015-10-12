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
    
    var cdPinCollection:PinCollection?
    
    func addPinToMap(lMapview: MKMapView, clearExistingTempPin:MKPointAnnotation?, gestureRecognizer:UIGestureRecognizer, isfinalLocationForPin:Bool)-> MKPointAnnotation {
        
        //use temporary pin when dragging and clear when done
        if let pinToRemove = clearExistingTempPin {
            //remove existing temp pin used for moving pin
            var pinsToRemove = [MKPointAnnotation]()
            pinsToRemove.append(pinToRemove)
            lMapview.removeAnnotations(pinsToRemove)
        }

        let touchpoint = gestureRecognizer.locationInView(lMapview)
        let touchmapCoord:CLLocationCoordinate2D = lMapview.convertPoint(touchpoint, toCoordinateFromView: lMapview)
        let location = touchmapCoord
        
        var newAnnotation = MKPointAnnotation()

        if isfinalLocationForPin {
            //save pin location
            let newPinView = Pin(llat: location.latitude, llong: location.longitude, llinksToImages: nil, context: sharedContext)
            
            var error: NSError?
            do {
                try sharedContext.save()
            } catch let error1 as NSError {
                error = error1
            }
            
            if let uw_error = error {
                print("error saving context: \(uw_error)")
            }
            let pinReference = newPinView.objectID
            newAnnotation = mapManager.createMapAnnotation(touchmapCoord,pinReference: pinReference)
        }
        else {
            //just generate the pin to drag
            newAnnotation = mapManager.createMapAnnotation(touchmapCoord,pinReference: nil)
        }
        
        
        lMapview.addAnnotation(newAnnotation)
        return newAnnotation
       
    }
    func removePinFromMap(mapview: MKMapView,pinView: MKAnnotationView) {
        let annotationToRemove = pinView.annotation
        mapview.removeAnnotation(annotationToRemove!)
        
        findMatchingPinInCollection(annotationToRemove!) { (matchedPin, error) -> Void in
            if let uw_error = error {
                print(uw_error)
            }
            else
            {
                self.sharedContext.deleteObject(matchedPin!)
                self.saveContext()
            }
        }
               
    }
    
    func addStoredPinsToMap(mp_mapview : MKMapView) {
       let mlistOfPins = PinHelper.sharedInstance().cdPinCollection!.getAllPins()
        mapManager.addPinsToMap(mp_mapview, listOfPins: mlistOfPins)
       
    }
    
    func findMatchingPinInCollection(AnnotationIDToMatch: MKAnnotation, completionHandler: (matchedPin: Pin?, error: String?)-> Void) {
        let pinsCD:[Pin] = PinHelper.sharedInstance().cdPinCollection!.getAllPins()
        for pinItem in pinsCD {
            let pinID = AnnotationIDToMatch.title
            let idToCompare = "\(pinItem.objectID)"
            if idToCompare == pinID! {
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