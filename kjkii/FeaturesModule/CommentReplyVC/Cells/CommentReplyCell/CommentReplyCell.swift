//
//  CommentReplyCell.swift
//  kjkii
//
//  Created by Shahbaz on 16/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class CommentReplyCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: APLabel!
    @IBOutlet weak var commentBody: APLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configCell(item: Replies){
        UIHelper.shared.setCell(cell: self)
        UIHelper.shared.setImage(address: item.user?.profile_pic ?? "", imgView: userImage)
        userName.text = item.user?.name
        commentBody.text = item.body
    }
    
}
