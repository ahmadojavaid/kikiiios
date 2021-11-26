//
//  YourMatchesCell.swift
//  kjkii
//
//  Created by Shahbaz on 05/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class YourMatchesCell: UITableViewCell {
    @IBOutlet weak var clcView: UICollectionView!
    @IBOutlet weak var clcHeight: NSLayoutConstraint!
    var matches = [Matches]()
    var delegate : MatchSelectedDelegate? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clcView.register(UINib(nibName: "MatchClcCell", bundle: nil), forCellWithReuseIdentifier: "MatchClcCell")
        clcView.delegate = self
        clcView.dataSource = self
        
    }
    
    func configCell(matches : [Matches]){
        self.matches = matches
        clcView.reloadData()
        let all = matches.count
        let rem = all % 2
        var found = Int()
        found = ((all - rem) / 2) + rem
        clcHeight.constant = CGFloat(found * 294)
    }
}

extension YourMatchesCell : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchClcCell", for: indexPath) as! MatchClcCell
        cell.configCell(item: matches[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 2) - 5 , height: 284)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.matchSelected(id: "\(matches[indexPath.row].id ?? 0)")
    }
}

protocol MatchSelectedDelegate {
    func matchSelected(id: String)
}
