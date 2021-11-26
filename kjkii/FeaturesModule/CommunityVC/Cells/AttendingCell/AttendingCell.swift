//
//  AttendingCell.swift
//  kjkii
//
//  Created by Shahbaz on 07/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class AttendingCell: UITableViewCell {
    
    @IBOutlet weak var clcHeight: NSLayoutConstraint!
    var attendess = [Attendant]()
    @IBOutlet weak var clcView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        clcView.register(UINib(nibName: "MathPeopleCell", bundle: nil), forCellWithReuseIdentifier: "MathPeopleCell")
        clcView.delegate = self
        clcView.dataSource = self
    }
    
    func configCell(attendess : [Attendant]){
        self.attendess = attendess
        self.clcView.reloadData()
        let height          = clcView.collectionViewLayout.collectionViewContentSize.height
        clcHeight.constant  = height
    }
    
}

extension AttendingCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attendess.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MathPeopleCell", for: indexPath) as! MathPeopleCell
        UIHelper.shared.setImage(address: attendess[indexPath.row].profilePic ?? "", imgView: cell.userImage)
        cell.countVIew.isHidden = true
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    
}
