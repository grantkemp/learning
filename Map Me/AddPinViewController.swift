//
//  AddPinViewController.swift
//  Map Me
//
//  Created by Grant Kemp on 6/14/15.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddPinViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate{

    @IBOutlet var vw_topView: UIView!
    @IBOutlet var btno_Cancel: UIButton!
    
    @IBOutlet var btno_findOnMap: UIButton!
    
    @IBOutlet var btno_submit: UIButton!
    
    @IBOutlet var lbl_topTextToChange: UILabel!
    @IBOutlet var lbl_topTextToHide: UILabel!
    @IBOutlet var lbl_topTextToHide2: UILabel!
    
    @IBOutlet var vw_LinkEntry: UIView!
    
    @IBOutlet var debug_lbl: UILabel!
    
    @IBOutlet var debug_lbl_enterAlink: UILabel!
    @IBOutlet var vw_findMapToHide: UIView!
    @IBOutlet var vw_BottomView: UIView!
    @IBOutlet var tf_Location: UITextField!
    
    @IBOutlet var tf_SubmitLink: UITextField!
    
    @IBOutlet var map_mapview: MKMapView!
    
    @IBOutlet var act_indicator: UIActivityIndicatorView!
    
    let gecoder = CLGeocoder()
    
    //output add a pin
    var locationTextToShow = ""
    var newEntryToSubmitLocation:MKPlacemark?
    var newEntryToSubmitLink:String = ""
    
    //output showPins
    var matchingItems = [MKMapItem]()

    //MARK: - BUTTONS
    
    @IBAction func btna_CancelScreen(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.resetMapView()
    }
    
    @IBAction func btna_FindOnMap(sender: AnyObject) {
          geocodeAddress(tf_Location.text)
    }
    
    @IBAction func btna_submit(sender: AnyObject) {
   submitDetailsForPin()
    }
    
    //MARK: View Loading Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show Default View
        let initialLocation = CLLocation(latitude: 51.5008025, longitude: -0.1246304)
        centreMapOnLcaton(initialLocation)
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
 
    override func viewWillAppear(animated: Bool) {
        //Add extra buttons to NavBar to add pin
        let pinButton = UIBarButtonItem(image: UIImage(named: "nav_locationPin"), style: UIBarButtonItemStyle.Plain, target: self, action: "addPin")
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshMap")
        
        self.navigationItem.rightBarButtonItems = [refreshButton,pinButton]
    
    }
    
    //MARK: Textfield methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "Enter your location here" {
            textField.text = ""
        }
        else if textField.text == "Enter A link" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        geocodeAddress(tf_Location.text)
        return false
    }

    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    //MARK: DATA SUBMISSION METHODS
    func submitDetailsForPin() {
        debug_lbl_enterAlink.hidden = true
        if tf_SubmitLink.text == "Enter a link" {
            //debug_lbl_enterAlink.text = "Enter a link to continue"
            debug_lbl_enterAlink.text = "http://www.connectedwindow.com"

        }
        else {
            //Validate Url
            if let url = NSURL(string: tf_SubmitLink.text) {
                self.newEntryToSubmitLink = tf_SubmitLink.text
                let longitude = Float(newEntryToSubmitLocation!.coordinate.longitude)
                let latitude = Float(newEntryToSubmitLocation!.coordinate.latitude)
                
                let studentInfoDict: [String: AnyObject] = ["firstname": UdacityClient.sharedInstance().userFirstName, "lastname": UdacityClient.sharedInstance().userLastName, "userId": UdacityClient.sharedInstance().userID, "latitude": latitude, "longitude": longitude ,"MapString": locationTextToShow, "MediaUrl": newEntryToSubmitLink]
                let studentInfo = StudentInformation(studentDetails: studentInfoDict)
             
    //Post new Student Pin to Feed
   ParseClient.sharedInstance().addPinTofeed(studentInfo, completionHandler: { (result, error) -> Void in
    if let downloadError = error {
        UdacityClient.sharedInstance().showDialogAlert("Oops there is an error", errorMessageSubtitle: "Something didn't work right", hostcontroller: self)
    }
    else {
        ParseClient.sharedInstance().usersObjectId = result!
        UdacityClient.sharedInstance().showDialogAlert("All Done", errorMessageSubtitle: "Pin succesfully posted reference:\(result)", hostcontroller: self)
   
    }
  
   })
            }
            else {
                //show error
                debug_lbl_enterAlink.hidden = false
                debug_lbl_enterAlink.text = "Invalid Url, enter a valid Url"
            }
            
        }
        
    }

    
    //MARK: Map Methods
    
    func centreMapOnLcaton(lLocation: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let region = MKCoordinateRegionMakeWithDistance(lLocation.coordinate, regionRadius * 20000, regionRadius * 20000)
        map_mapview.setRegion(region, animated: true)
    }
    
    func setupMapView() {
        //Do animations to setup map view
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.vw_findMapToHide.backgroundColor = UIColor.clearColor()
            self.debug_lbl.hidden = true
            self.btno_findOnMap.hidden = true
            self.btno_submit.hidden = false
            
            self.lbl_topTextToHide.hidden = true
            self.lbl_topTextToHide2.hidden = true
            self.lbl_topTextToChange.hidden = true
            self.vw_LinkEntry.hidden = false
            self.btno_Cancel.titleLabel?.textColor = GlobalConstants.sharedInstance().whiteColour
            self.vw_topView.backgroundColor = GlobalConstants.sharedInstance().blueColour
            self.tf_Location.hidden = true
            self.map_mapview.hidden = false
        })

    }
    
    func resetMapView() {
        //Return screen to original when cancelled
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.vw_findMapToHide.backgroundColor = GlobalConstants.sharedInstance().greyColour
            self.debug_lbl.hidden = true
            self.debug_lbl_enterAlink.hidden = true
            
            self.btno_findOnMap.hidden = false
            self.btno_submit.hidden = true
            
            self.lbl_topTextToHide.hidden = false
            self.lbl_topTextToHide2.hidden = false
            self.lbl_topTextToChange.hidden = false
            self.vw_LinkEntry.hidden = true
            self.btno_Cancel.titleLabel?.textColor = GlobalConstants.sharedInstance().blueColour
            self.vw_topView.backgroundColor = GlobalConstants.sharedInstance().greyColour
            self.tf_Location.hidden = false
            self.tf_Location.text = "Enter your location here"
            self.map_mapview.hidden = true
            
            //reset constants 
            self.locationTextToShow = ""
        })
        
    }

    func geocodeAddress(address:String) {
        //looks up address based on text string
        self.act_indicator.startAnimating()
        self.locationTextToShow = tf_Location.text
        
        self.gecoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
            self.act_indicator.stopAnimating()
            if let mapError = error {
                UdacityClient.sharedInstance().showDialogAlert(mapError.localizedDescription, errorMessageSubtitle: "Unable to find this  location, please try a diiferent location" , hostcontroller: self)
            }
            else {
                //no error - lets show the place
                let placemark1 = placemarks[0] as! CLPlacemark
                let convertedPlacemark: MKPlacemark = MKPlacemark(placemark: placemark1)
                self.newEntryToSubmitLocation = convertedPlacemark
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(convertedPlacemark.coordinate.latitude, convertedPlacemark.coordinate.longitude)
                let span: MKCoordinateSpan = MKCoordinateSpanMake(1, 1)
                var regionTouse = MKCoordinateRegionMake(coordinate, span)
                self.map_mapview.region = regionTouse
                
                //Generate Annotation to confirm pin location
                var annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = convertedPlacemark.title
                annotation.subtitle = "Here I am"
                self.map_mapview.addAnnotation(annotation)
                self.setupMapView()
            }

        })
    }

}
