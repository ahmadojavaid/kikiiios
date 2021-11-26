//
//  OnlineCell.swift
//  kjkii
//
//  Created by Shahbaz on 05/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class OnlineCell: UITableViewCell {

    @IBOutlet weak var clcView: UICollectionView!
    
    var onlineUsers = [Online_users]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        clcView.register(UINib(nibName: "OnlineUserClcCell", bundle: nil), forCellWithReuseIdentifier: "OnlineUserClcCell")
        clcView.delegate    = self
        clcView.dataSource  = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension OnlineCell : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onlineUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnlineUserClcCell", for: indexPath) as! OnlineUserClcCell
        
//        UIHelper.shared.setImage(address: onlineUsers[indexPath.row].profile_pic ?? "", imgView: cell.userImage)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    
}
