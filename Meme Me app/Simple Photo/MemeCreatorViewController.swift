//
//  ViewController.swift
//  Simple Photo
//
//  Created by Grant Kemp on 4/16/15.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import UIKit

class MemeCreatorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate{
    
    
    @IBOutlet var btn_ChangeFont: UIBarButtonItem!
    @IBOutlet var tb_footToolbar: UIToolbar!
    @IBOutlet var btn_cancel: UIBarButtonItem!
    @IBOutlet var btn_share: UIBarButtonItem!
    @IBOutlet var tf_top: UITextField!
    @IBOutlet var tf_bottom: UITextField!
   
    @IBOutlet var btn_Camera: UIBarButtonItem!
    @IBOutlet var img_mainImage: UIImageView!

    //TODO: Fix image capturing so that it goes full screen with image
    
    
    var meme:Meme?
    var textFieldShouldShiftView: Bool = false
    let kTOPTEXTFIELD: Int = 0
    let kBOTTOMTEXTFIELD: Int = 1
    var savedRef: Int?
    var isEditingMode = false
    var currentFontRef = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        if let mMeme = meme {
            setupTextField(tf_top, mPlaceholder: mMeme.topText!)
            setupTextField(tf_bottom, mPlaceholder: mMeme.bottomText!)
            savedRef = mMeme.memeId
            img_mainImage.image = mMeme.originalImage
            btn_share.enabled = true
            btn_cancel.enabled = true
            btn_ChangeFont.enabled = true
        }
        else {
        
        //setup blank meme
        setupTextField(tf_top, mPlaceholder: "TOP")
        setupTextField(tf_bottom, mPlaceholder: "BOTTOM")
        }
        }
    override func viewWillAppear(animated: Bool) {
        //check if Camera is available
        let isCameraEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        if (isCameraEnabled){
            btn_Camera.enabled = true
        }
        
        // listen for keyboard notifications in order to shift view
        self.subscribeToKeyboardNotifications()
    
    }
    override func viewWillDisappear(animated: Bool) {
        self.unsubscribeToKeyboardNotifications()
    }
//MEME ACTION Methods
    func saveMeme() {
        
        //if Editing existing Meme, then update the same meme reference
        if (meme != nil){
         //we are saving an already stored meme
            
            let imageToCreate =  createMemeImage()
            meme = Meme(lmemeId: meme!.memeId!, ltoptext: tf_top.text!, lbottomText: tf_bottom.text!, lolImg: img_mainImage.image!, lmemImg: imageToCreate, lfont: tf_top.font! )
            meme?.saveToAppDelegateWithRef()
           
        }else {
            //store a new meme
           
            let imageToCreate =  createMemeImage()
            meme = Meme(ltoptext: tf_top.text!, lbottomText: tf_bottom.text!, lolImg: img_mainImage.image!, lmemImg: imageToCreate, lfont: tf_top.font! )
            
            meme?.saveToAppDelegateAsNewItem()
      
        }
    
    }
    
    
    func createMemeImage() -> UIImage {
       
            // Render the current view to a Memed Image, remove toolbars before render, and get them back when dismissing the UIActivityViewController of Share button
            
            navigationController?.navigationBar.hidden = true
            self.tb_footToolbar.hidden = true
            
            UIGraphicsBeginImageContext(self.view.frame.size)
            self.view.drawViewHierarchyInRect(self.view.frame,afterScreenUpdates: true)
            let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            navigationController?.navigationBar.hidden = false
            self.tb_footToolbar.hidden = false
            return memedImage
        
    
    }
    
//BUTTONS
    
    @IBAction func btn_act_changeFont(sender: AnyObject) {
       changeFonts([tf_top,tf_bottom])
        
       
    }
    
    @IBAction func btn_cancel(sender: AnyObject) {
        if (isEditingMode) {
            //dismissview controller
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            //segue to history view
             performSegueWithIdentifier("showHistory", sender: self)
        }
        
    }
    
    @IBAction func sharePhoto(sender: AnyObject) {
        
     if let shareController = meme?.generateShareController()
     {
        presentViewController(shareController, animated: true) { () -> Void in
        }
        }
     else {
        print("meme not created")
        
        }
    }


    @IBAction func selectImageFromCamera(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(picker, animated: true, completion: nil)
    }
    @IBAction func selectImage(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(picker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.img_mainImage.image = image
            btn_share.enabled = true
            btn_cancel.enabled = true
            saveMeme()
        }
            self.dismissViewControllerAnimated(true, completion: nil)
    }
 
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //TEXT FIELD METHODS
    
    func setupTextField(mTextField: UITextField, mPlaceholder: String) {
       
        // Setup properties 
        let memeTextAttributes = [
            
            NSStrokeColorAttributeName : UIColor.grayColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3
           

        ]
        mTextField.defaultTextAttributes = memeTextAttributes
        mTextField.text = mPlaceholder
        mTextField.delegate = self
        mTextField.textAlignment = NSTextAlignment.Center
        mTextField.textColor = UIColor.whiteColor()
        mTextField.adjustsFontSizeToFitWidth = true
        
        //Tag with which version it is so we can choose to adjust view later
        if mPlaceholder == "TOP" {
            mTextField.tag = kTOPTEXTFIELD
        }
        else {
            mTextField.tag = kBOTTOMTEXTFIELD
        }
        
    }
    func changeFonts(fieldstoChange: [UITextField]) {
        //Build list of fonts and change Text field fonts to next one
        
        let fontList = AppFonts().getAllFonts()
        if (currentFontRef == fontList.count - 1 ) {
            currentFontRef = 0
        }
        else {
            currentFontRef++
        }
        for field in fieldstoChange {
            field.font = fontList[currentFontRef]        }
        
        self.saveMeme()
        
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        //if bottom text field is selected then opening kb should shift view
        if (textField.tag == kBOTTOMTEXTFIELD){
            textFieldShouldShiftView = true
        }
        textField.text = ""
    }
    func textFieldDidEndEditing(textField: UITextField) {
        self.saveMeme()
        if (btn_ChangeFont.enabled == false){
            btn_ChangeFont.enabled = true
            
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    //KEYBOARD ADJUSTING VIEW METHODS
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "kbWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "kbWillHide:", name: UIKeyboardWillHideNotification, object: nil)

    }
    func unsubscribeToKeyboardNotifications() {
       NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    func kbWillShow(notification: NSNotification) {
        //Check if TextField edit should shift view up
        if (textFieldShouldShiftView) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
           }
    func kbWillHide(notification: NSNotification) {
        //Check if TextField edit should shift view down
        if (textFieldShouldShiftView) {
        self.view.frame.origin.y += getKeyboardHeight(notification)
        self.textFieldShouldShiftView = false
        }
        
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        return keyboardSize.CGRectValue().height
    }
   

}

