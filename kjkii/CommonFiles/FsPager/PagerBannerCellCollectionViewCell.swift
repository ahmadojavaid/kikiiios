//
//  PagerBannerCellCollectionViewCell.swift
//  kjkii
//
//  Created by Saeed Rehman on 07/01/2021.
//  Copyright © 2021 abbas. All rights reserved.
//

import UIKit
import FSPagerView
class PagerBannerCellCollectionViewCell: FSPagerViewCell {

    @IBOutlet weak var bannerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setDate (item: BannerImages){
        UIHelper.shared.setImage(address: item.path ?? "", imgView: bannerImage)
    }
}
