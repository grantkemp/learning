//
//  StudentTableViewController.swift
//  Map Me
//
//  Created by Grant Kemp on 6/19/15.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import UIKit

class StudentTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var tbl_tableview: UITableView!
    
    //MARK: Buttons
    
    @IBAction func btna_refreshAction(sender: AnyObject) {
        reloadData()
    }
    
    @IBAction func btna_addAPin(sender: AnyObject) {
    }
    var students = [StudentInformation]()
    
    //methodVariables
    var isDownloaded = false
    override func viewDidLoad() {
        super.viewDidLoad()
reloadData()


        // Do any additional setup after loading the view.
    }
    @IBAction func btna_logout(sender: AnyObject) {
        UdacityClient.sharedInstance().logoutUser(self, completionhandler: { (isloggedout, error) -> Void in
            if (isloggedout) {
                println("logged out")
            }
            else
            {
                println("There was an error")
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        //build navigationController
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let pinButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_LocationPin"), style: UIBarButtonItemStyle.Plain, target: self, action: "addAPin")
        let refreshButton: UIBarButtonItem = UIBarButtonItem(title: "Refresh", style: UIBarButtonItemStyle.Plain, target: self, action: "reloadData")
        self.navigationItem.setRightBarButtonItems([refreshButton, pinButton], animated: false)

           }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isDownloaded {
            return students.count
        }
        else {
            return 1
        }
    
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        if (isDownloaded) {
        cell.textLabel?.text = students[indexPath.row].fullname
            cell.imageView?.image = UIImage(named: "nav_locationPin")
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let urlString = students[indexPath.row].mediaURL
        if let url = NSURL(string: urlString) {
            UIApplication.sharedApplication().openURL(url)
        }
        else {
            println("invalid url")
        }
    }
    
    func reloadData(){
        isDownloaded = false
        ParseClient.sharedInstance().getStudents { (result, error) -> Void in
            if let downloadError = error {
                //Unable to download students
            }
            else {
                self.students = ParseClient.sharedInstance().studentGrouplist.studentList
                self.isDownloaded = true
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                     self.tbl_tableview.reloadData()
                })
            }
        }
    }
    func addAPin() {
        performSegueWithIdentifier("addPin", sender: self)
    }
}
