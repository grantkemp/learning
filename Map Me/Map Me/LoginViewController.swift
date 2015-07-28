//
//  ViewController.swift
//  Map Me
//
//  Created by Grant Kemp on 6/14/15.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var debug_form: UILabel!
    
    @IBOutlet var tf_Email: UITextField!
    
    @IBOutlet var tf_Password: UITextField!
    
    //MARK: Buttons
    
    @IBAction func btna_Login(sender: AnyObject) {
       self.debug_form.hidden = true
        if tf_Email.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "Email" {
            self.debug_form.hidden = false
            self.debug_form.text = "Enter in your email"
        }
        else if tf_Password.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "Password" {
            self.debug_form.hidden = false
            self.debug_form.text = "Enter in your password"
        }
        else {
        //Authenticate
        UdacityClient.sharedInstance().Authenticate(tf_Email.text, lpassword: tf_Password.text, completionHandler: { (authenticated, error) -> Void in
            if let loginError = error {
                if loginError.code == 403 { // invalid credentials
                    UdacityClient.sharedInstance().showDialogAlert("Incorrect Details", errorMessageSubtitle: "Please check your details and try again", hostcontroller: self)
                }
                else {
                    if loginError.code == -1009 { // no internet
                        UdacityClient.sharedInstance().showDialogAlert("No internet Connection", errorMessageSubtitle: "Please check your connection and try again", hostcontroller: self)
                    }
                }
               
            }
            else {
                self.onLogInMovetoNextView()
            }
        })        }
    }
    
    //MARK: View Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup tap to dismiss kb
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
    }

    //MARK: Textfield methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
  
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    //MARK: Main activity Methods
    func onLogInMovetoNextView() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.performSegueWithIdentifier("showMap", sender: self)
        })
    }
    
    }

