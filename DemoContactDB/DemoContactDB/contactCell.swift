//
//  contactCell.swift
//  DemoContactDB
//
//  Created by vibha on 28/11/18.
//  Copyright © 2018 vibha. All rights reserved.
//

import UIKit

class contactCell: UITableViewCell {

    @IBOutlet var imgContcat: UIImageView!
    
    @IBOutlet var lblname: UILabel!
    
    @IBOutlet var lblNumber: UILabel!
    
    @IBOutlet var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
