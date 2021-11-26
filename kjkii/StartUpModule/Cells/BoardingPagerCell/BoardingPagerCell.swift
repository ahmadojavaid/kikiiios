//
//  BoardingPagerCell.swift
//  kjkii
//
//  Created by abbas on 7/25/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import FSPagerView

class BoardingPagerCell: FSPagerViewCell {
    
    @IBOutlet weak var lblTitle: APLabel!
    @IBOutlet weak var lblDetails1: APLabel!
    @IBOutlet weak var lblDetails2: APLabel!
    @IBOutlet weak var imgView: UIImageView!
    
    func setData(imgName:String, title:String, details1:String, details2:String) {
        imgView.image = UIImage(named: imgName)
        lblTitle.text = title
        lblDetails1.text = details1
        lblDetails2.text = details2
    }
    
    func setDateFromcall(item: OnBoardingImages){
        
        UIHelper.shared.setImage(address: item.path ?? "", imgView: imgView)
        lblTitle.text = item.title
        lblDetails1.text = item.description
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
