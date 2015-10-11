//
//  appFonts.swift
//  Simple Photo
//
//  Created by Grant Kemp on 4/27/15.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import Foundation
import UIKit

struct AppFonts {
    //Should this be done as an Enum??
    let systemFont = UIFont.systemFontOfSize(30)
    let avenirBlack = UIFont(name: "Avenir-Black", size: 35)
    let baskerville = UIFont(name: "Baskerville", size: 35)
    let copperplate = UIFont(name: "Copperplate", size: 35)
    let noteworthy = UIFont(name: "Noteworthy-Bold", size: 35)
    
    func getAllFonts() -> [UIFont?] {
        let listofFonts = [avenirBlack,baskerville,copperplate,noteworthy]
        return listofFonts
    }
    
    func changeSize(font: UIFont, lsize: CGFloat) -> UIFont {
        return font.fontWithSize(lsize)
    }
}
