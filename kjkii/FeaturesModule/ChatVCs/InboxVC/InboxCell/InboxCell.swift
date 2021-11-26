//
//  InboxCell.swift
//  kjkii
//
//  Created by Shahbaz on 05/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class InboxCell: UITableViewCell {
    @IBOutlet weak var userImg      : UIImageView!
    @IBOutlet weak var timeLabel    : APLabel!
    @IBOutlet weak var userName     : APLabel!
    @IBOutlet weak var messageBody  : APLabel!
    @IBOutlet weak var nextBtn      : UIButton!
    func configCell(item: InboxFbMsgs){
        let time            = Date(milliseconds: Int64(Double(item.time) ?? 0.0))
        timeLabel.text      = timeIntervalWithDate(dateWithTime: time)
        userName.text       = item.userName
        messageBody.text    = item.message
        UIHelper.shared.setImage(address: item.img, imgView: userImg)
    }
    
}
