//
//  FriendCell.swift
//  kjkii
//
//  Created by abbas on 8/29/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var name         : APLabel!
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var cellTypeIcon : UIImageView!
    @IBOutlet weak var sideBtn      : UIButton!
    var type:CellType = .iconfriend
    func setData(type:CellType, item: Sentrequests) {
        self.type = type
        cellTypeIcon.image = UIImage(named: type.rawValue)
        name.text = item.name
        UIHelper.shared.setImage(address: item.profile_pic ?? "", imgView: profileImage)
    }
    func setDataFriends(type:CellType, item: friendsData) {
        self.type = type
        cellTypeIcon.image = UIImage(named: type.rawValue)
        name.text = item.name
        UIHelper.shared.setImage(address: item.profile_pic ?? "", imgView: profileImage)
    }
    func setDataPending(type:CellType, item: Pendingrequests) {
        self.type = type
        cellTypeIcon.image = UIImage(named: type.rawValue)
        name.text = item.name
        UIHelper.shared.setImage(address: item.profile_pic ?? "", imgView: profileImage)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    enum CellType:String {
        case iconfriend,iconpending, iconreqsent
    }
    
}
