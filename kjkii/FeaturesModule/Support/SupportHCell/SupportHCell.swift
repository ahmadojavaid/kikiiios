//
//  SupportHCell.swift
//  kjkii
//
//  Created by abbas on 8/29/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class SupportHCell: UITableViewCell {

    @IBOutlet weak var mainBtn: UIButton!
    @IBOutlet weak var label: APLabel!
    @IBOutlet weak var lineView: UIView!
    
    func setData(text:String, type:CellType = .default) {
        label.text = text
        if type == .center {
            label.textAlignment = .center
            label.customize(.font16, .bold, .grayText)
            lineView.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    enum CellType {
        case `default`, center
    }
    
}
