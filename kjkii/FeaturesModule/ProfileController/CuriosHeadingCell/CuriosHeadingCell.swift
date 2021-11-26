//
//  CuriosHeadingCell.swift
//  kjkii
//
//  Created by abbas on 8/26/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class CuriosHeadingCell: UITableViewCell {

    @IBOutlet weak var label: APLabel!
    
    func setData(title:String) {
        label.text = title
        label.customize(.font20, .bold, .redText)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
