//
//  DetailViewController.swift
//  Simple Photo
//
//  Created by Grant Kemp on 4/21/15.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var selectedMemeId: Int?
    var localMeme: Meme?
    
     @IBOutlet var img_selectedMeme: UIImageView!
    
    //BUTTONS
    @IBAction func deleteMeme(sender: AnyObject) {
        localMeme?.deleteMeme(localMeme!.memeId!)
      //  self.dismissViewControllerAnimated(true, completion: nil)
    navigationController?.popViewControllerAnimated(true)
    
    }
    @IBAction func shareMeme(sender: AnyObject) {
       
        if let shareController = localMeme?.generateShareController() {
        presentViewController(shareController, animated: true) { () -> Void in
        }
            
        }
        else
        {
            print("no meme generated to share")
        }
    }
    @IBAction func editImage(sender: AnyObject) {
        performSegueWithIdentifier("editImage", sender: self)
    }
   
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
       /// refreshMemeImageFromAppdelegate()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editImage" {
            let destController = segue.destinationViewController as! MemeCreatorViewController
            destController.meme = localMeme
            destController.isEditingMode = true
        }
    }
    override func viewWillAppear(animated: Bool) {
        //loading image from id as dismissing view controller doesn't show viewdidload
       refreshMemeImageFromAppdelegate()
        
    }
    func refreshMemeImageFromAppdelegate() {
        localMeme = Meme(lmemeId: selectedMemeId!)
       img_selectedMeme.image = localMeme?.memeImage

    }

}
