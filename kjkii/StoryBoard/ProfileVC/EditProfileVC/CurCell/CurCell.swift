//
//  CurCell.swift
//  kjkii
//
//  Created by Shahbaz on 06/11/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class CurCell: UICollectionViewCell {
    @IBOutlet weak var optionLabel: APLabel!
    func configCell(item: String){
        optionLabel.text = item
    }
}

