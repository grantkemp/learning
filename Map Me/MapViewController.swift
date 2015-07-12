//
//  MapViewController.swift
//  Map Me
//
//  Created by Grant Kemp on 6/14/15.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet var mp_mapview: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    var gkLocationManager = CLLocationManager()

    //MARK: View Methodss
    override func viewDidLoad() {
        
       //set initial location
         let initialLocation = CLLocation(latitude: 51.5008025, longitude: -0.1246304)
        centreMapOnLcaton(initialLocation)
           }
    
    override func viewWillAppear(animated: Bool) {
        self.refreshPins()
    }
 //MARK: buttons
    @IBAction func btna_logout(sender: AnyObject) {
        //Logout with Facebook
             UdacityClient.sharedInstance().logoutUser(self, completionhandler: { (isloggedout, error) -> Void in
        if (isloggedout) {
            println("logged out")
        }
        else
        {
            println("There was an error in logging out")
        }
       })
    }

    //MARK: Map Methods
    func centreMapOnLcaton(lLocation: CLLocation) {
        let region = MKCoordinateRegionMakeWithDistance(lLocation.coordinate, regionRadius * 20000, regionRadius * 20000)
        mp_mapview.setRegion(region, animated: true)
    }
    func addAPin() {
        performSegueWithIdentifier("addPin", sender: self)
    }
    func refreshPins() {
        ParseClient.sharedInstance().getStudents() { (result, error) -> Void in
            if let downloaderror = error {
                UdacityClient.sharedInstance().showDialogAlert(downloaderror.code.description, errorMessageSubtitle: downloaderror.localizedDescription, hostcontroller: self)
            }
            else if let successResult = result {
                if let downloadedAnnotations = ParseClient.sharedInstance().generateAnnotationsfor(ParseClient.sharedInstance().studentGrouplist.studentList) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.mp_mapview.addAnnotations(downloadedAnnotations)
                    })
                }
            }
        }
        
        //build navigationController
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let pinButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_LocationPin"), style: UIBarButtonItemStyle.Plain, target: self, action: "addAPin")
        let refreshButton: UIBarButtonItem = UIBarButtonItem(title: "Refresh", style: UIBarButtonItemStyle.Plain, target: self, action: "refreshPins")
        self.navigationItem.setRightBarButtonItems([refreshButton, pinButton], animated: false)
    }
    //MARK: Mapview Controller

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
      //generate annotations to show on map
        let pin = "student"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(pin) as? MKPinAnnotationView
        if annotationView == nil {
             annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pin)
            
        }
        annotationView!.canShowCallout = true
        annotationView!.pinColor = MKPinAnnotationColor.Purple
        annotationView!.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
        return annotationView
    }

    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        //open browser when clicking annotation
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation.subtitle!)!)
        }

    }
}
