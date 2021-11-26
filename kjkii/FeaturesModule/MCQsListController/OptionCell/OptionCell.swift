//
//  OptionCell.swift
//  kjkii
//
//  Created by abbas on 8/29/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class OptionCell: UITableViewCell {
    
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var imgChecked: UIImageView!
    @IBOutlet weak var label: APLabel!
    
    func setData(text:String, type:CellType) {
        label.text = text
        label.customize(.font18, .regular, (type == .selected || type == .lastSelected) ? .redText:.darkText)
        sepratorView.isHidden = (type == .last || type == .lastSelected)
        imgChecked.isHidden = (type == .default || type == .last)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    enum CellType {
        case selected, `default`, last, lastSelected
    }
    
}
