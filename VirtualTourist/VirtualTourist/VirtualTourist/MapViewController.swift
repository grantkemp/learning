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


class MapViewController: UIViewController,MKMapViewDelegate{
    
    var pins = [CLLocationCoordinate2D]()

    // Outbound Vars
    var selectedPin:Pin?
    //Mark: MethodVariables
    var isInEditingMode = false
    let k_DELETEBUTTONHEIGHTFORMOVINGMAPVIEWUP:CGFloat = 40
    var newAnnotation = MKPointAnnotation() // used to keep a handle on new pins being generated so we can delete previous pin when dragging and holding in MapView
    //Dragging Methods for new pin
    var pinState = k_PINMODE.none
    enum k_PINMODE {
    case none, pinNew, pinDragging,pinDragEnded
    }
    
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
        //FIRST Run checkIf Core Data Pin Collection exists, if not create one
       var collectionToUse =  self.fetchPinCollection() //TODO: refactor to setup album in Helper
pinManager.cdPinCollection = collectionToUse
        
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
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.Began:
            pinState = k_PINMODE.pinNew
            newAnnotation = pinManager.addPinToMap(mp_mapview, clearExistingTempPin: nil, gestureRecognizer: gestureRecognizer,isfinalLocationForPin: false)
            return
        case UIGestureRecognizerState.Changed:
            pinState = k_PINMODE.pinDragging
            newAnnotation = pinManager.addPinToMap(mp_mapview, clearExistingTempPin: newAnnotation, gestureRecognizer: gestureRecognizer, isfinalLocationForPin:false)
            return
        case UIGestureRecognizerState.Ended:
           pinState = k_PINMODE.none
            newAnnotation = pinManager.addPinToMap(mp_mapview, clearExistingTempPin: newAnnotation, gestureRecognizer: gestureRecognizer, isfinalLocationForPin: true)
            newAnnotation = MKPointAnnotation() // Blank the temporary holder
            
            return
        default:
            println("Oops, unknown Gesture recogniser state: \(gestureRecognizer)")
        }

    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        if (isInEditingMode) {
            //Delete the Pin
            pinManager.removePinFromMap(mapView, pinView: view)
        }
        else {
          //  check if there is a matching ObjectId
            pinManager.findMatchingPinInCollection(view.annotation, completionHandler: { (matchedPin, error) -> Void in
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
        }
        else {
            pinView!.annotation = annotation
        }
        if pinState == k_PINMODE.pinNew {
         pinView!.animatesDrop = true
        }
        else {
            pinView!.animatesDrop = false
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
    func fetchPinCollection() -> PinCollection {
        var fetchError: NSErrorPointer = nil
        var mainCollection:PinCollection?
        
        //create the fetch request
        let fetchRequest = NSFetchRequest(entityName: "PinCollection")
        
        //execute the request
        let results = sharedContext.executeFetchRequest(fetchRequest, error: fetchError)
        
        if fetchError != nil {
            println("Error fetching results")

        }
        else {
            //first result always shown as there is only 1 collection
            let resultsCount = results!.count
            if results?.count == 0 {
                //create a  new default collection
                mainCollection = PinCollection(createNew: true, context: sharedContext)
                
            }
            else {
                mainCollection = results?.first as! PinCollection
                println(mainCollection)
            }
            
        }
        return mainCollection!
    }

}