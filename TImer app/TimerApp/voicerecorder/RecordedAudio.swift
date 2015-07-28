//
//  RecordedAudio.swift
//  TimerApp
//
//  Created by Grant Kemp on 4/6/15.
//  Copyright (c) 2015 alexanderkustov. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(path: NSURL, mainTitle: String) {
        self.filePathUrl = path
        self.title = mainTitle
    }
}
