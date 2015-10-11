//
//  MemeTableViewCell.swift
//  Simple Photo
//
//  Created by Grant Kemp on 4/19/15.
//  Copyright (c) 2015 Grant Kemp. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet var img_MemeThumbnail: UIImageView!
    @IBOutlet var lbl_MemeDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
