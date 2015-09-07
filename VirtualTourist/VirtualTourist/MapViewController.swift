//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Grant Kemp on 21/08/2015.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import UIKit
import MapKit
import CoreData

/**
* In this step the view controller conforms to NSFetchedRequestControllerDelegate
*
* We needed to make three changes:
*
* 1. declare that we will conform to the protocol, in the line below
* 2. set the view controller as the fetchedResultsController's delegate (in viewDidLoad)
* 3. implement the four protocol methods
*
*/



class MapViewController: UIViewController,MKMapViewDelegate{
    
    var pins = [CLLocationCoordinate2D]()
    
    
    
    // Outbound Vars
    var selectedPin:Pin?
    //Mark: MethodVariables
    var isInEditingMode = false
    let k_DELETEBUTTONHEIGHTFORMOVINGMAPVIEWUP:CGFloat = 40
    
    // Helpers
    var mapManager = MapHelper()
    var pinManager = PinHelper.sharedInstance()
    
    @IBOutlet weak var mp_mapview: MKMapView!
   
    @IBOutlet weak var vw_buttonBottomBar: UIView!
    
    @IBOutlet weak var out_btn_nav_editButton: UIBarButtonItem!
    @IBOutlet weak var out_btn_deletePins: UIButton!
    //Mark: Buttons: 
    
    @IBAction func act_btn_editPins(sender: AnyObject) {
        if isInEditingMode {
            isInEditingMode = false
            out_btn_nav_editButton.title = "Edit"
            
            //Hide Red Delete instructions
            var oldHeight = out_btn_deletePins.frame.height
            var oldWidth = out_btn_deletePins.frame.width

            UIView.animateWithDuration(0.5, animations: { () -> Void in

                self.mp_mapview.bounds  = CGRectMake(self.mp_mapview.bounds.origin.x, self.mp_mapview.bounds.origin.y-40, self.mp_mapview.bounds.width, self.mp_mapview.bounds.height)
                
                
                self.vw_buttonBottomBar.bounds = CGRectMake(self.vw_buttonBottomBar.bounds.origin.x, self.vw_buttonBottomBar.bounds.origin.y, self.vw_buttonBottomBar.bounds.width, self.vw_buttonBottomBar.bounds.height-80)
            })
        }
        else {
            isInEditingMode = true
            out_btn_nav_editButton.title = "Done"
            UIView.animateWithDuration(0.5, animations: { () -> Void in
               
                self.mp_mapview.bounds  = CGRectMake(self.mp_mapview.bounds.origin.x, self.mp_mapview.bounds.origin.y+40, self.mp_mapview.bounds.width, self.mp_mapview.bounds.height)
                
                self.vw_buttonBottomBar.bounds = CGRectMake(self.vw_buttonBottomBar.bounds.origin.x, self.vw_buttonBottomBar.bounds.origin.y, self.vw_buttonBottomBar.bounds.width, self.vw_buttonBottomBar.bounds.height+80)
    
            })

        }
        
    }
    
    @IBAction func act_btn_deletePins(sender: AnyObject) {
        //save if want to bulk delete pins
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add Long Press to Map
        let lpgr = UILongPressGestureRecognizer(target: self, action: "addPintoMap:")
        lpgr.minimumPressDuration = 1
        mp_mapview.addGestureRecognizer(lpgr)
        mp_mapview.delegate = self
        
        if let mapRegion =  mapManager.getSavedPositionOfMap().mapSetup {
            mp_mapview.region = mapRegion
        }
        
        pinManager.addStoredPinsToMap(mp_mapview)
        
    }

    //Mark: Map Methods
    
    func addPintoMap(gestureRecognizer: UIGestureRecognizer) {
        if (gestureRecognizer.state) != UIGestureRecognizerState.Ended {
            return
        }
        else {
            let touchpoint = gestureRecognizer.locationInView(mp_mapview)
            let touchmapCoord:CLLocationCoordinate2D = mp_mapview.convertPoint(touchpoint, toCoordinateFromView: mp_mapview)
            
            pinManager.addPinToMap(mp_mapview, location: touchmapCoord)
            
        }
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        if (isInEditingMode) {
            //Delete the Pin
            pinManager.removePinFromMap(mapView, pinView: view)
        }
        else {
            //check if there is a matching ObjectId
            pinManager.findMatchingPinInCollcetion(pinManager.pinsCD, AnnotationIDToMatch: view.annotation, completionHandler: { (matchedPin, error) -> Void in
                if let un_error = error {
                    println(error)
                }
                else {
                    self.selectedPin = matchedPin
                    self.performSegueWithIdentifier("showPinView", sender: self)
                }
            })
            
           
        }
        
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"

        var pinView = mp_mapview.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.animatesDrop = true
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPinView" {
            let destController = segue.destinationViewController as! PhotoAlbumViewController
           
            
            destController.selectedPin = selectedPin!
        }
    }
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        var newLocation = mapView.region
        mapManager.savePositionOfMapToLocal(newLocation)    }

//MARK: Coredata - store Items
    func insertNewPin(sender: AnyObject) {
    
    // Step 4: Create an Event object (and append it to the events array.)
    
    
    // Step 5: Save the context (and check for an error)
    // (see the actorPicker(:didPickActor:) method for an example
    
    var error: NSError?
    
    sharedContext.save(&error)
    
    if let error = error {
    println("error saving context: \(error)")
    }
    

    }
//MARK: Coredata Methods
    
    
    lazy var sharedContext: NSManagedObjectContext =  {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
        }()
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }

    
    
//MARK: CoreData Methods- fetched results controller // Not Enabled 
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
    }
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
    }
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
    }
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        
    }
    
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        // Create the fetch request
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        
        // Add a sort descriptor.
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        
        // Create the Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Return the fetched results controller. It will be the value of the lazy variable
        return fetchedResultsController
        } ()

    
}