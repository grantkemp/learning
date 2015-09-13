//
//  Maphelper.swift
//  VirtualTourist
//
//  Created by Grant Kemp on 28/08/2015.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import CoreData


class MapHelper: NSObject {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    //Constants
    let k_REGIONKEY = "regionToUse"
    let k_CENTRE_LAT = "centrelat"
    let k_CENTRE_LONG = "centrelong"
   let K_REGION_SPAN_LAT = "RegionSpanLat"
    let K_REGION_SPAN_LONG = "RegionSpanLong"
    
    
    //Mark: Map Setup Methods
    
    func setupsmallMap(pinLocation:Pin, mapview: MKMapView) {
        
        let centreOfMapPoint = CLLocationCoordinate2DMake(pinLocation.lat, pinLocation.long)
        let viewRegion =  self.setupRegion(centreOfMapPoint, smallMap: true)
        mapview.setRegion(viewRegion, animated: true)
        mapview.setCenterCoordinate(centreOfMapPoint, animated: true)
        mapview.addAnnotation(createMapAnnotation(centreOfMapPoint,pinReference: pinLocation.objectID))
        
    }
    
    func addPinsToMap(mapview: MKMapView, listOfPins:[Pin]) {
        for pinItem in listOfPins {
            let annotationForMap = self.createMapAnnotation(CLLocationCoordinate2DMake(pinItem.lat, pinItem.long), pinReference: pinItem.objectID)
            mapview.addAnnotation(annotationForMap)
        }

    }
    
    func createMapAnnotation(touchmapCoord: CLLocationCoordinate2D, pinReference:NSManagedObjectID?) -> MKPointAnnotation{
        let annotation = MKPointAnnotation()
        annotation.coordinate = touchmapCoord
        if let uw_pinref = pinReference {
        annotation.title = "\(uw_pinref)"
        }
        
        return annotation
    }
    
    func setupRegion(centreOfMapPoint: CLLocationCoordinate2D, smallMap: Bool) -> MKCoordinateRegion {
        
        var region = MKCoordinateRegionMakeWithDistance(centreOfMapPoint, 120000, 120000)
        return region
    }
    
    
    //MARK: Persistance
    func savePositionOfMapToLocal(region: MKCoordinateRegion) {
       defaults.setDouble(region.center.latitude, forKey: k_CENTRE_LAT)
        defaults.setDouble(region.center.longitude, forKey: k_CENTRE_LONG)
        defaults.setDouble(region.span.latitudeDelta, forKey: K_REGION_SPAN_LAT)
        defaults.setDouble(region.span.longitudeDelta, forKey: K_REGION_SPAN_LONG)
    }
    
    func getSavedPositionOfMap() -> (isAvailable: Bool, mapSetup: MKCoordinateRegion?) {
      
        if let lat = defaults.objectForKey(k_CENTRE_LAT) as? CLLocationDegrees {
            let long = defaults.objectForKey(k_CENTRE_LONG) as! CLLocationDegrees
            let regionLat = defaults.objectForKey(K_REGION_SPAN_LAT) as! CLLocationDistance
            let regionLong = defaults.objectForKey(K_REGION_SPAN_LONG) as! CLLocationDistance
            
            let regionToUse =   MKCoordinateRegionMake(CLLocationCoordinate2DMake(lat, long), MKCoordinateSpanMake(regionLat, regionLong))
                return (true, regionToUse )
        }
        else {
            return (false,nil)
        }
    }
}