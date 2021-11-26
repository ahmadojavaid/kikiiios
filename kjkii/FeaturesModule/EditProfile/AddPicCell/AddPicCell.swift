//
//  AddPicCell.swift
//  kjkii
//
//  Created by abbas on 8/29/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class AddPicCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ProfilePicsCell", bundle: .main), forCellWithReuseIdentifier: "ProfilePicsCell")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCollectionView()
    }
}

extension AddPicCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePicsCell", for: indexPath) as! ProfilePicsCell
        return cell
    }
}

extension AddPicCell {
    func layoutCollectionView() {
        //let widthRation = CGFloat(375.0/415.0)
        let edgeInset:CGFloat =  0 //* widthRation
        //let viewWidth:CGFloat = 400.0 //(.bounds.size.width - (40.0 * widthRation))/3.0
        let width = collectionView.frame.size.width/3 - 1
        let height = width
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 0.0 //* widthRation // Veritical Space
        layout.minimumLineSpacing = 0.0 //* widthRation      // HorizSpace
        //layout.headerReferenceSize = CGSize(width: 0, height: 35)
        layout.sectionInset = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
    }
}
