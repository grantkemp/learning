//
//  MemeCollection.swift
//  Simple Photo
//
//  Created by Grant Kemp on 4/20/15.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var historymemes: [Meme]!
    var selectedMeme: Meme?
    var widthOfCells: CGFloat!
    var widthOfCellsusingCGRect : CGFloat!
    var  heightOfCells: CGFloat!
    
   

    @IBOutlet var col_CollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Semi-Persistent Storage
        updateSourceData()
        
        col_CollectionView.allowsSelection = true
        
    
    }
    override func viewWillAppear(animated: Bool) {
        //refresh data if any changes on the other table view
        updateSourceData()
        self.col_CollectionView.reloadData()
    }
    
    func updateSourceData() {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        historymemes = appDelegate.memes
    }

//DATASOURCE METHODS
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfRows = historymemes.count
        
        return numberOfRows
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        cell.img_MemeImage.image = historymemes[indexPath.row].memeImage
        
        return cell
        
    }
//DELEGATE METHODS
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedMeme = historymemes[indexPath.row]
        performSegueWithIdentifier("showDetail", sender: self)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetail") {
            let destcontroller = segue.destinationViewController as! DetailViewController
            destcontroller.selectedMemeId = self.selectedMeme!.memeId!
            destcontroller.hidesBottomBarWhenPushed = true
        }
    }


}

