//
//  LikeCell.swift
//  kjkii
//
//  Created by Shahbaz on 01/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class LikeCell: UITableViewCell {
    @IBOutlet weak var upgradeLbl: APLabel!
    
    @IBOutlet weak var clcView: UICollectionView!
    @IBOutlet weak var totalLikeLbl: APLabel!
    
    var likes = [Likes]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if DEFAULTS.string(forKey: "isPaid") == "0" {
            upgradeLbl.isHidden = false
        }else{
            upgradeLbl.isHidden = true
        }
        clcView.register(UINib(nibName: "MathPeopleCell", bundle: nil), forCellWithReuseIdentifier: "MathPeopleCell")
        
        clcView.delegate = self
        clcView.dataSource = self
    }
    
    func configCell(likes : [Likes]){
        self.likes = likes
        if DEFAULTS.string(forKey: "isPaid") != "0" {
        clcView.reloadData()
        }
        
        totalLikeLbl.text = "\(self.likes.count) likes"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension LikeCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likes.count > 4 ? 4 : likes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MathPeopleCell", for: indexPath) as! MathPeopleCell
        cell.countVIew.isHidden = true
        UIHelper.shared.setImage(address: likes[indexPath.row].profile_pic ?? "", imgView: cell.userImage)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    
}
