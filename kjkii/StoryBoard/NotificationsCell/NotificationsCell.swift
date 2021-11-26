//
//  NotificationsCell.swift
//  kjkii
//
//  Created by Shahbaz on 09/11/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class NotificationsCell: UITableViewCell {

    @IBOutlet weak var notiTime: APLabel!
    @IBOutlet weak var notiTxt: APLabel!
    @IBOutlet weak var notiImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
