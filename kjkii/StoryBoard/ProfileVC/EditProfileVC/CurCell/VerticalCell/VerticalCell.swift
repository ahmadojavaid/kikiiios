//
//  VerticalCell.swift
//  kjkii
//
//  Created by Shahbaz on 06/11/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class VerticalCell: UICollectionViewCell {
    @IBOutlet weak var optionName: APLabel!
    @IBOutlet weak var selectedImage: UIImageView!
    func configCell(item: McqOptions){
        optionName.text = item.itemName
        selectedImage.isHidden = !item.isSelected
    }

}
