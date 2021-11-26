//
//  BlockedCells.swift
//  kjkii
//
//  Created by Saeed Rehman on 18/01/2021.
//  Copyright © 2021 abbas. All rights reserved.
//

import UIKit

class BlockedCells: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var btnBlock: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
