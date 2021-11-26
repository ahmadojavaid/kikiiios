//
//  MainCommentCell.swift
//  kjkii
//
//  Created by Shahbaz on 16/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class MainCommentCell: UITableViewCell {

    @IBOutlet weak var commentBody: APLabel!
    @IBOutlet weak var userName: APLabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configMainComment(item: Comments){
        commentBody.text = item.body
        UIHelper.shared.setCell(cell: self)
        UIHelper.shared.setImage(address: item.user?.profile_pic ?? "", imgView: userImage)
        userName.text = item.user?.name
    }

    
}
