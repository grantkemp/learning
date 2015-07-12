//
//  Constants.swift
//  Map Me
//
//  Created by Grant Kemp on 6/14/15.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation
import UIKit

class GlobalConstants: NSObject {
    let blueColour: UIColor = UIColor.blueColor()
    let greyColour: UIColor = UIColor.grayColor()
    let whiteColour: UIColor = UIColor.whiteColor()


// MARK: - Shared Instance

class func sharedInstance() -> GlobalConstants {
    
    struct Singleton {
        static var sharedInstance = GlobalConstants()
    }
    return Singleton.sharedInstance
}
}
