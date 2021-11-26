//
//  TableViewCell.swift
//  kjkii
//
//  Created by abbas on 8/25/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnUpgrade: APButton!
    
    func setData(target:Any, selector:Selector, isHidden:Bool) {
        btnUpgrade.addTarget(target, action: selector, for: .touchUpInside)
        btnUpgrade.isHidden = isHidden
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
