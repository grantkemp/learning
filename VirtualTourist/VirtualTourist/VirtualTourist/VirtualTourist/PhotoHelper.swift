//
//  PhotoHelper.swift
//  VirtualTourist
//
//  Created by Grant Kemp on 05/09/2015.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class PhotoHelper: NSObject {
    
    
    
        
    func saveUrlsToPin(pinItem: Pin, urlsToStore: [String]) {
        //create new Photos
        for urlItem in urlsToStore {
            let newPhoto = Photo(lphotoUrl: urlItem, pinToUse: pinItem, context: sharedContext)
            saveContext()
        }
        
    }
    
    //MARK: CoreData
    
    lazy var sharedContext: NSManagedObjectContext =  {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
        }()
    
    func saveContext() {
        CoreDataStackManager.sharedInstance().saveContext()
    }
}