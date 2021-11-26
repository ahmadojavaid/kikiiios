//
//  MCQsCollectionController.swift
//  kjkii
//
//  Created by abbas on 8/31/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class MCQsCollectionController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblQuestion: APLabel!
    
    var mData:[String] = []
        
    var isSelected:[Bool] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        isSelected = Array(repeating: false, count: mData.count)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "MCQsCell", bundle: .main), forCellWithReuseIdentifier: "MCQsCell")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutCollectionView()
    }
    
    @IBAction func btnSavePressed(_ sender: Any) {
    }
    
}

extension MCQsCollectionController:UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MCQsCell", for: indexPath) as! MCQsCell
        //cell.setData(item: mData[indexPath.row], isSelected:false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isSelected[indexPath.row] = true //!isSelected[indexPath.row]
        (collectionView.cellForItem(at: indexPath) as? MCQsCell)?.set(selected: isSelected[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        isSelected[indexPath.row] = false
        (collectionView.cellForItem(at: indexPath) as? MCQsCell)?.set(selected: isSelected[indexPath.row])
    }
}

extension MCQsCollectionController {
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

extension MCQsCollectionController: UICollectionViewDelegateFlowLayout {
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
