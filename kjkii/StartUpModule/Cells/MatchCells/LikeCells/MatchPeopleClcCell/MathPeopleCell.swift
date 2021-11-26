//
//  MathPeopleCell.swift
//  kjkii
//
//  Created by Shahbaz on 01/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class MathPeopleCell: UICollectionViewCell {

    @IBOutlet weak var countVIew: UIView!
    @IBOutlet weak var countLBl: APLabel!
    @IBOutlet weak var userImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}




class DynamicHeightCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
