//
//  UdacityConienceMethods.swift
//  Map Me
//
//  Created by Grant Kemp on 6/21/15.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {
    
    
    //MARK: Authentication Methods
    func Authenticate(lusername: String, lpassword: String, completionHandler:(authenticated:Bool?, error: NSError?) -> Void) {
        let debugusername = "ENTER YOUR DEBUG USERNAME HERE"
        let debugpassword = "ENTER YOUR DEBUG PASSWORD HERE"
        let methodToUse = Methods.apiSession
        let params:[String: AnyObject] = [
            ParameterKeys.username: debugusername,
            ParameterKeys.password: debugpassword
        ]
    //Setup Request
        var requestJson = [RequestJsonKeys.udacity: [RequestJsonKeys.username: lusername, RequestJsonKeys.password: lpassword]]
        
        if UdacityConfig.inDebugMode {
             //have debug version for testing
              requestJson = [RequestJsonKeys.udacity: [RequestJsonKeys.username: debugusername, RequestJsonKeys.password: debugpassword]]
        }
        var parsingError:NSError?
        var entryData = NSJSONSerialization.dataWithJSONObject(requestJson, options: nil, error: &parsingError)
        
        taskForPost(methodToUse, jsonBodyAsData: entryData!) { (result, error) -> Void in
            if let downloadError = error {
                 completionHandler(authenticated: false, error: downloadError)
            }
            else {
                var parsingError: NSError?
                let newDataDecoded = NSJSONSerialization.JSONObjectWithData(result!, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! [String: AnyObject]
                if let authError = newDataDecoded[ResponseJsonKeys.error] {
                    let errorToShare = NSError(domain: newDataDecoded[ResponseJsonKeys.error] as! String, code: newDataDecoded[ResponseJsonKeys.status] as! Int, userInfo: newDataDecoded)
                    completionHandler(authenticated: false, error: errorToShare)
                }
                else {
                    
                    //get User ID 
                    let account = newDataDecoded[ResponseJsonKeys.account] as! [String:AnyObject]
                    let userIdDownloaded = account[ResponseJsonKeys.account_key] as! String
self.userID = userIdDownloaded
                    //Get Session Id
                    let session = newDataDecoded[ResponseJsonKeys.session] as! [String:AnyObject]
                    
                    if let newSessionIDDownloaded =  session[ResponseJsonKeys.session_id] as? String {
                        
                        //Get Session and User Details
                        self.sessionID = newSessionIDDownloaded
                        self.getUserDetails({ (userDetails, error) -> Void in
                            if let userError = error {
                                completionHandler(authenticated: false, error: error)
                            }
                            else {

                                self.getUserDetails({ (fullname, error) -> Void in
                                    if let downloadError = error {
                                        completionHandler(authenticated: false, error: error)
                                    }
                                    else {
                                        completionHandler(authenticated: true, error: nil)
                                    }
                                })
                            }
                        })
                        
                    }
                  
                }
                
            }
        }
        
    }
    

    

   
    func logoutUser(hostController: UIViewController, completionhandler: (isloggedout:Bool, error:NSError?) -> Void) {

        
        UdacityClient.sharedInstance().taskForDelete(Methods.apiSession) { (result, error) -> Void in
            if let downloaderror = error {
                completionhandler(isloggedout: false, error: error)
            }
            else {
                var parsingError: NSError?
                if let jsonDecoded = NSJSONSerialization.JSONObjectWithData(result!, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as?
                [String: [String: AnyObject]] {
                    let sessionDeleted = jsonDecoded[ResponseJsonKeys.session]
                   dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.resetAppToLogin(hostController)
                   })
                   
                    
                     completionhandler(isloggedout: true, error: nil)
                }
               
            }
        }
        
}
    
    func resetAppToLogin(hostController: UIViewController) {
        
        //clear main auth variables
        self.userID = ""
        self.sessionID = ""
        self.usedFacebook = false
        var userFirstName = ""
        var userLastName = ""
        
        var controller: LoginViewController
        
        controller = hostController.storyboard?.instantiateViewControllerWithIdentifier("loginpage") as! LoginViewController
        hostController.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    //MARK: Utility Methods
    
    func getUserDetails(completionHandler: (gotDetails: Bool?, error: NSError?)-> Void) {
        let methodToUse = Methods.users
        
        UdacityClient.sharedInstance().taskForGet(methodToUse, completionHandler: { (result, error) -> Void in
            if let downloadError = error {
                completionHandler(gotDetails: false, error: downloadError)
            }
            else {
                var parsingError:NSError?
                if let jsonDecoded = NSJSONSerialization.JSONObjectWithData(result!, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as? [String:[String: AnyObject]] {
                    
                    if let jsonDecoded_user = jsonDecoded[ResponseJsonKeys.user] as [String:AnyObject]! {
                        
                        let firstname = jsonDecoded_user[ResponseJsonKeys.firstname] as! String
                        let lastname = jsonDecoded_user[ResponseJsonKeys.lastname] as! String
                        
                        UdacityClient.sharedInstance().userFirstName = firstname
                        UdacityClient.sharedInstance().userLastName = lastname
                        completionHandler(gotDetails: true, error: nil)
                        
                    }
                }
            }
        })
    }
    

    
    
    func showDialogAlert(errorMessageTitle: String, errorMessageSubtitle: String,  hostcontroller: UIViewController) {
        var alert = UIAlertController(title: errorMessageTitle, message: errorMessageSubtitle, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: { () -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    println("this isn't showing")
                    hostcontroller.dismissViewControllerAnimated(true, completion: nil)

                })
                
            })
            
            
            
            
            
        }))
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
               hostcontroller.presentViewController(alert, animated: true, completion: nil)
        })
     
    }
}
