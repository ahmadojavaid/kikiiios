//
//  TableCollectionCell.swift
//  kjkii
//
//  Created by abbas on 7/30/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class TableCollectionCell: UITableViewCell {
    
    var isUpgraded = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    var mData:[String] = [
        "Gender Identity", "Sexual Identity", "Pronoun", "Relationship Status", "Looking For", "Drinking", "Smoking", "Cannabis", "Political Views", "Religion", "Diet", "Pets", "Star Sign", "Family Preferences", "Last Online"
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "FilterCell", bundle: .main), forCellWithReuseIdentifier: "FilterCell")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCollectionView()
    }
}

extension TableCollectionCell:UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as! FilterCell
        cell.bgView.backgroundColor = isUpgraded ? #colorLiteral(red: 0.8882552981, green: 0.1654957235, blue: 0.1417197287, alpha: 1):#colorLiteral(red: 0.5999328494, green: 0.6000387073, blue: 0.5999261737, alpha: 1)
        cell.lblName.text = mData[indexPath.row]
        return cell
    }
}

extension TableCollectionCell {
    func layoutCollectionView() {
        //let widthRation = CGFloat(375.0/415.0)
        /*
        let edgeInset:CGFloat =  20 // * widthRation
        //let viewWidth:CGFloat = 400.0 //(.bounds.size.width - (40.0 * widthRation))/3.0
        let width = 150
        let height = 45
    
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 20.0 // * widthRation // Veritical Space
        layout.minimumLineSpacing = 20.0 // * widthRation      // HorizSpace
        //layout.headerReferenceSize = CGSize(width: 0, height: 35)
        layout.sectionInset = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
        */
        
        let edgeInset:CGFloat =  20
        let width = 150
        let height = 45
        
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 20.0
        layout.minimumLineSpacing = 20.0

        layout.sectionInset = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
        
        
    }
}

extension TableCollectionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // dataArary is the managing array for your UICollectionView.
        let item = mData[indexPath.row]
        var itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font : Theme.Font.ofSize(.font18, weight: .semiBold)
        ])
        itemSize.width += 50
        itemSize.height += 20
        return itemSize
    }
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
