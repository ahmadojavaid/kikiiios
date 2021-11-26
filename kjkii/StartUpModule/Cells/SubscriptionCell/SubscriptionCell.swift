//
//  SubscriptionCell.swift
//  kjkii
//
//  Created by abbas on 7/28/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import FSPagerView

class SubscriptionCell: FSPagerViewCell {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var mpImageView: UIImageView!
    @IBOutlet weak var lblMonths: APLabel!
    @IBOutlet weak var lblRupeePM: APLabel!
    @IBOutlet weak var lblRupee: APLabel!
    
    func setData(currencyType:String, ammount:Double, type:CellType) {
        lblMonths.text = "1\nMonth"
        lblRupee.text = "\(currencyType) \(Int(ammount))"
        bgImageView.image = UIImage(named: "bgview")
        lblRupeePM.isHidden = true
        mpImageView.isHidden = false
        lblRupee.textColor = Theme.Colors.darkText
//        switch type {
//        case .OneMonth:
//            lblMonths.text = "1\nMonth"
//            lblRupee.text = "\(currencyType) \(Int(ammount))"
//            bgImageView.image = UIImage(named: "bgview")
//            lblRupeePM.isHidden = true
//            mpImageView.isHidden = true
//            lblRupee.textColor = Theme.Colors.darkText
//        case .OneYearPop:
//            lblMonths.text = "12\nMonths"
//            lblRupee.text = "\(currencyType) \(Int(ammount))"
//            bgImageView.image = UIImage(named: "bgview_redborder")
//            lblRupeePM.text = "\(currencyType) \(Int(ammount/12))/mo"
//            lblRupeePM.isHidden = false
//            mpImageView.isHidden = false
//            lblRupee.textColor = Theme.Colors.redText
//        case .OneYear:
//            lblMonths.text = "12\nMonths"
//            lblRupee.text = "\(currencyType) \(Int(ammount))"
//            bgImageView.image = UIImage(named: "bgview")
//            lblRupeePM.text = "\(currencyType) \(Int(ammount/12))/mo"
//            lblRupeePM.isHidden = false
//            mpImageView.isHidden = true
//            lblRupee.textColor = Theme.Colors.darkText
//        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    enum CellType {
        case OneMonth, OneYearPop, OneYear
    }

}
