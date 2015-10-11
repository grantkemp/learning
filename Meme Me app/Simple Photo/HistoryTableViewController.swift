//
//  HistoryTableViewController.swift
//  Simple Photo
//
//  Created by Grant Kemp on 4/19/15.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import UIKit

class HistoryTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var startEditing: UIBarButtonItem!
 
    @IBOutlet var mTableview: UITableView!
    var historymemes: [Meme]!
    var selectedMeme: Meme?
    var mAppDelegate: AppDelegate?

   
    //BUTTONS
    
    @IBAction func btn_startEditing(sender: AnyObject) {
        
        // Setup Edit button
        if (self.navigationItem.leftBarButtonItem?.title == "Done") {
           self.mTableview.setEditing(false, animated: true)
            self.navigationItem.leftBarButtonItem?.title = "Edit"
            
        }
        else
        {
            self.mTableview.setEditing(true, animated: true)
            self.navigationItem.leftBarButtonItem?.title = "Done"
        }
        
     mTableview.reloadData()
        
    }
    
        override func viewDidLoad() {
        super.viewDidLoad()
        let object = UIApplication.sharedApplication().delegate
        mAppDelegate = object as? AppDelegate
        historymemes = mAppDelegate!.memes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
    //DATASOURCE METHODS
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return historymemes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! MemeTableViewCell
        cell.lbl_MemeDescription.text = historymemes[indexPath.row].topText
        cell.img_MemeThumbnail.image = historymemes[indexPath.row].memeImage
       
        return cell
    }

    //DATA DELEGATE METHODS
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedMeme = historymemes[indexPath.row]
        performSegueWithIdentifier("showDetail", sender: self)
        
    }
   // EDITING Content methods
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
      
            self.historymemes.removeAtIndex(indexPath.row)
            mAppDelegate?.memes.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
        default:
            return
    }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "new Meme" {
            

        } else if segue.identifier == "showDetail" {
            let destcontroller = segue.destinationViewController as! DetailViewController
            destcontroller.selectedMemeId = self.selectedMeme!.memeId!
            destcontroller.hidesBottomBarWhenPushed = true
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //if edits have happened, then lets refresh the contents of the table
        historymemes = mAppDelegate!.memes
        mTableview.reloadData()
    }

}
