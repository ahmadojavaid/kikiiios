//
//  APLabel.swift
//  TheICERegister
//
//  Created by abbas on 5/13/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class APLabel: UILabel {
    
    var color: TextColors   = .whiteText
    var weight: FontWeight  = .regular
    var size: FontSize!     = .font17
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.customization()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customization()
    }
    
    convenience init(fontSize:FontSize, color:TextColors = .darkText, weight:FontWeight = .regular ) {
        self.init(frame: CGRect())
        customize(fontSize, weight, color)
    }
    
    
    func customize(_ fontSize: FontSize, _ weight: FontWeight, _ color: TextColors) {
        self.size = fontSize
        self.weight = weight
        self.color = color
        customization()
    }
    
    fileprivate func customization(){
        translatesAutoresizingMaskIntoConstraints = false
        font = Theme.Font.ofSize(self.size, weight: self.weight)
        textColor = self.color.value
        tintColor = Theme.Colors.tint
    }
    
    @IBInspectable var setWeight:String {
        set {
            self.weight = FontWeight(rawValue: newValue) ?? FontWeight.regular
            self.customization()
        }
        get {
            return self.weight.value
        }
    }
    
    @IBInspectable var setSize:Int {
        set {
            self.size = FontSize(rawValue: newValue) ?? FontSize.font17
            self.customization()
        }
        get {
            return self.size.value
        }
    }
    
    @IBInspectable var setColor:String {
        set {
            self.color = TextColors(rawValue: newValue) ?? TextColors.darkText
            self.customization()
        }
        get {
            return self.color.raw
        }
    }
}
