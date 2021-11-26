//
//  EventCell.swift
//  kjkii
//
//  Created by Shahbaz on 06/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import Toast_Swift

class EventCell: UITableViewCell {
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet var imgConstraints: [NSLayoutConstraint]!
    @IBOutlet weak var clcContainerView : UIView!
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: APLabel!
    @IBOutlet weak var dateLabel: APLabel!
    @IBOutlet weak var clcView: UICollectionView!
    var count = Int()
    var id = String()
    var attendees = [Attendant]()
    func configCell(item: Event){
        id = "\(item.id)"
        attendees = item.attendants
        UIHelper.shared.setImage(address: item.coverPic!, imgView: eventImage)
        eventTitle.text = item.name
        dateLabel.text = item.eventDescription
        clcView.register(UINib(nibName: "MathPeopleCell", bundle: nil), forCellWithReuseIdentifier: "MathPeopleCell")
        clcView.delegate = self
        clcView.dataSource = self
        clcView.reloadData()
        
        if attendees.count > 5 {
            count = 5
        }
        else{
            count = attendees.count
        }
        
    }
    
    
    
}

extension EventCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MathPeopleCell", for: indexPath) as! MathPeopleCell
        UIHelper.shared.setImage(address: attendees[indexPath.row].profilePic ?? "", imgView: cell.userImage)
        if indexPath.row < 4{
            cell.countVIew.isHidden = true
        }
        else{
            cell.countVIew.isHidden = false
            cell.countLBl.text = "\(attendees.count - 4)+"
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    
}
