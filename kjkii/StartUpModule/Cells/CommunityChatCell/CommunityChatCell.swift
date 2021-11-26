//
//  CommunityChatCell.swift
//  kjkii
//
//  Created by Shahbaz on 07/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class CommunityChatCell: UITableViewCell {

    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var userName: APLabel!
    @IBOutlet weak var commentText: APLabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var replyBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configCell(item: Comments){
        UIHelper.shared.setCell(cell: self)
        userName.text = item.user?.name
        commentText.text = item.body
        UIHelper.shared.setImage(address: item.user?.profile_pic ?? "", imgView: userImage)
        
    }

    
    
}
