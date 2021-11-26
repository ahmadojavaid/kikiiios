//
//  MCQsCell.swift
//  kjkii
//
//  Created by abbas on 8/31/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class MCQsCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblText: APLabel!
    
    func setData(item: McqOptions) {
        lblText.text = item.itemName
        set(selected: item.isSelected)
    }
    
    func set(selected:Bool){
        if selected {
            lblText.textColor = Theme.Colors.whiteText
            bgView.backgroundColor = Theme.Colors.redText
        } else {
            lblText.textColor = Theme.Colors.redText
            bgView.backgroundColor = .clear
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

struct McqOptions {
    var itemName = String()
    var isSelected = Bool()
}
