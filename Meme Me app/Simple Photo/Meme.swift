//
//  Meme.swift
//  Simple Photo
//
//  Created by Grant Kemp on 4/18/15.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    let memeId: Int?
    var topText: String?
    var bottomText: String?
    let originalImage: UIImage?
    let memeImage: UIImage?
    let font:UIFont?
    
    static let topTextKey = "nameKey"
    static let bottomTextKey = "bottomText"
    static let originalImageKey = "originalImage"
    
    
    init(lmemeId: Int, ltoptext: String, lbottomText: String, lolImg: UIImage, lmemImg: UIImage,lfont: UIFont){
        //Set up meme for editing
        self.memeId = lmemeId
        self.topText = ltoptext
        self.bottomText = lbottomText
        self.originalImage = lolImg
        self.memeImage = lmemImg
        self.font = lfont
    }

    init(ltoptext: String, lbottomText: String, lolImg: UIImage, lmemImg: UIImage, lfont: UIFont){
        //Set up meme for first time ( ie not editing)
       self.topText = ltoptext
        self.bottomText = lbottomText
        self.originalImage = lolImg
        self.memeImage = lmemImg
        self.font = lfont
        
        //calculate id 
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        self.memeId = appDelegate.memes.count

        
    }
    init(lmemeId: Int){
    // Load Meme from ID ( Used for Editing)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
       let selectedMeme = appDelegate.memes[lmemeId]
        
        self.memeId = lmemeId
        self.topText = selectedMeme.topText
        self.bottomText = selectedMeme.bottomText
        self.originalImage = selectedMeme.originalImage
        self.memeImage = selectedMeme.memeImage
        self.font = selectedMeme.font
        
        
        
        
    }

    //Helper methods
    
    func generateShareController() -> UIActivityViewController {
        
        var sharedItems = [AnyObject]()
        sharedItems.append(memeImage!)
        
        let actController = UIActivityViewController(activityItems: sharedItems, applicationActivities: nil)
        
        return actController

    }
    func saveToAppDelegateWithRef() {
        //Open Up appdelegate for saving
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes[self.memeId!] = self
    }
    
    func saveToAppDelegateAsNewItem() {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(self)
    }
    
    func deleteMeme(lref: Int) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.removeAtIndex(lref)
        
    }
}




