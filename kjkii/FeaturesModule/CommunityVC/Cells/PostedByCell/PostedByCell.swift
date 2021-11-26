//
//  PostedByCell.swift
//  kjkii
//
//  Created by Shahbaz on 07/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class PostedByCell: UITableViewCell {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usreName: APLabel!
    
    func configCell(user: CommunityUser){
        UIHelper.shared.setCell(cell: self)
        UIHelper.shared.setImage(address: user.profile_pic ?? "", imgView: userImage)
        usreName.text = user.name
        
    }
    
}
