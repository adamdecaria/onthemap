//
//  StudentLocationTableViewCell.swift
//  On The Map
//
//  Created by Adam DeCaria on 2017-02-13.
//  Copyright © 2017 Adam DeCaria. All rights reserved.
//

import UIKit

class StudentLocationTableViewCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var locationIconImage: UIImageView!
    @IBOutlet weak var StudentNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
} // End StudentLocationTableViewCell
