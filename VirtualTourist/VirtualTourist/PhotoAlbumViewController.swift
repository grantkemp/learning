//
//  PinViewViewController.swift
//  VirtualTourist
//
//  Created by Grant Kemp on 21/08/2015.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    //input from Previous Controller
    var selectedPin: Pin?
    
    //method
    var selectedCells = [Int: NSIndexPath]()
    var isEditingImages = false
    
    //helper
    var mapManager = MapHelper()
    var pinManager = PinHelper.sharedInstance()
    var photoManager = PhotoHelper()
    
    //CollectionView Sources
    
    @IBOutlet weak var out_btn_viewCollection: UIButton!
    @IBOutlet weak var col_PinCollection: UICollectionView!
    @IBOutlet weak var mp_topMapview: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadnewPinPics()
        
        
    }
    override func viewWillAppear(animated: Bool) {
    mapManager.setupsmallMap(selectedPin!, mapview: mp_topMapview)
    }
    
    
    //MARK: Buttons
    
    @IBAction func act_btn_ViewCollection(sender: AnyObject) {
        if isEditingImages {
             var itemToDeleteArray = [NSIndexPath]()
            var photosToDelete = [Photo]()
            for (key,indexpath) in selectedCells {
                println("deleting key \(key)")
                
                //TODO: fix deleting images to prevent array being out of order"
                if let selectedPhoto = selectedPin?.attachedPhotos.allObjects[indexpath.row] as? Photo {
               photosToDelete.append(selectedPhoto)
                itemToDeleteArray.append(indexpath)
                }
            }
            selectedPin?.deleteImages(photosToDelete, context: sharedContext, completionHandler: { (complete, error) -> Void in
               var itemsInCollectionView = self.selectedPin?.attachedPhotos.allObjects.count
                
                self.col_PinCollection.deleteItemsAtIndexPaths(itemToDeleteArray)
                
                self.resetCollectionViewToDefaults()
                itemToDeleteArray.removeAll(keepCapacity: false)
                photosToDelete.removeAll(keepCapacity: false)
                
self.downloadnewPinPics()
            })
            

        }
        else {
            let allImagesList:[Photo] = selectedPin?.attachedPhotos.allObjects as! [Photo]
         selectedPin?.deleteImages(allImagesList, context: sharedContext, completionHandler: { (complete, error) -> Void in
            self.downloadnewPinPics()
         })
            
        }
        
        
    }
// MARK: CollectionView Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedPin!.attachedPhotos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PinViewCollectionViewCell
     let photoForCell = self.selectedPin?.attachedPhotos.allObjects[indexPath.row] as! Photo
        
        //ShowPlaceholder Image
        cell.img_Thumbnail.image = UIImage(named: "PlaceholderImage")
        if cell.selected {
            cell.vw_overlay.alpha = 0.8
        }
        else {
            cell.vw_overlay.alpha = 0
        }
       
        // Display Image
        var imageToDisplay = UIImage()
        println("---")
        println((selectedPin?.attachedPhotos.allObjects[indexPath.row] as! Photo).getCachedPath())
        println("---")
        if photoForCell.cacheddUrl != "" {
            //its cached, therefor show it
            
            var fileExists = NSFileManager.defaultManager().fileExistsAtPath(photoForCell.getCachedPath())
            if  let cachedImage = UIImage(contentsOfFile: photoForCell.getCachedPath()) {
                imageToDisplay = cachedImage
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    cell.act_cellActivityIndicator.stopAnimating()
                    cell.img_Thumbnail.image = imageToDisplay
                })

            }
        }
        else {
            //Download it
            photoForCell.downloadImageToLocalDisk({ (localImagePath, error) -> Void in
              
                let cachedImagePath = photoForCell.getCachedPath()
                let cachedImage = photoForCell.cacheddUrl
                if let uw_error = error {
                    println("error downloading image")
                }
                else {
//                    let  newlyDownloadedImagePath = localImagePath
//                    photoForCell.cacheddUrl = newlyDownloadedImagePath
                    
                    if let newlyDownloadedImage = UIImage(contentsOfFile: photoForCell.getCachedPath()) {
                        imageToDisplay = newlyDownloadedImage
                   
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.act_cellActivityIndicator.stopAnimating()
                        cell.img_Thumbnail.image = imageToDisplay
                        
                    })
                    }
                    
                }
            })
     
           
    }

        
        
    
    return cell
}
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //activate editing Mode if not on
        if !isEditingImages {
            out_btn_viewCollection.titleLabel?.text = "Press to delete images"
            isEditingImages = true
            
        }
       let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PinViewCollectionViewCell
        
            if self.selectedCells[indexPath.row] == nil {
                self.selectedCells[indexPath.row] = indexPath
                cell.vw_overlay.alpha = 0.8
                cell.selected = true
            }
            else {
                self.selectedCells.removeValueForKey(indexPath.row)
                cell.vw_overlay.alpha = 0
                cell.selected = false
            }

       
        
        
    }
    
    //MARK: Helper Functions:
    func downloadnewPinPics(){
        
        FlickrClient.sharedInstance().GetFlickrPhotoUrls(self.selectedPin!) { (resultPinAlbum, error) -> Void in
            if let pinDownloadError = error {
                println("unable to download pins")
                let errorDescription = error?.localizedDescription
                self.showDialogAlertInternet("Oops, there has been an error", errorMessage: errorDescription!)
            }
            else {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.col_PinCollection.reloadData()
                }
            }
        }

    }
    
    func showDialogAlertInternet(title: String, errorMessage: String) {
        var alert = UIAlertController(title: "Oops", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            alert.dismissViewControllerAnimated(true, completion: { () -> Void in
                println("alert removed")
                
            })

        }))
        
        self.presentViewController(alert, animated: true) { () -> Void in
            navigationController?.popViewControllerAnimated(true)
        }
    }
    func resetCollectionViewToDefaults() {
        isEditingImages = false
        self.out_btn_viewCollection.titleLabel?.text = "New Collection"
        self.selectedCells.removeAll(keepCapacity: false)
            }
    //MARK: Coredata Methods
    
    
    lazy var sharedContext: NSManagedObjectContext =  {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
        }()
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }

}
