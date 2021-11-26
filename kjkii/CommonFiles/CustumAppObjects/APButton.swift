//
//  APButton.swift
//  TheICERegister
//
//  Created by abbas on 5/13/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
//@IBDesignable
open class APButton:UIButton {

    var image:UIImage?
    var buttonStyle:ButtonStyle = .simple
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.customization()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customization()
    }
    
    convenience init(style:ButtonStyle, image:UIImage? = nil) {
        self.init(frame: CGRect())
        self.image = image
        self.buttonStyle = style
        customization()
    }
    
    func customize(_ title:String? = nil, font fontSize: FontSize, _ weight: FontWeight, _ color: TextColors, for state:UIControl.State) {
        if let title = title {
            setTitle(title, for: state)
        }
        titleLabel?.font = Theme.Font.ofSize(fontSize, weight: weight)
        setTitleColor(color.value, for: state)
    }
    
    fileprivate func customization(){
        /*
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .center
        
        self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        */
        translatesAutoresizingMaskIntoConstraints = false
        //setImage(nil, for: .normal)
        setBackgroundImage(nil, for: .normal)
        titleLabel?.font = Theme.Font.ofSize(.font18, weight: .semiBold)
        isEnabled = true
        tintColor = Theme.Colors.tint

        switch buttonStyle {
        case .simple:
            setTitleColor(Theme.Colors.redText, for: .normal)
        case .`default`:
            setTitleColor(Theme.Colors.whiteText, for: .normal)
            backgroundColor = Theme.Colors.redText
            cornerRadius = 5
            botLeftRadius = 20
        case .green:
            setTitleColor(Theme.Colors.whiteText, for: .normal)
            backgroundColor = Theme.Colors.greenText
            cornerRadius = 5
            botLeftRadius = 20
        case .default30:
            setTitleColor(Theme.Colors.whiteText, for: .normal)
            backgroundColor = Theme.Colors.redText
            titleLabel?.numberOfLines = 0
            titleLabel?.textAlignment = .center
            cornerRadius = 5
            botLeftRadius = 30
        case .default1030:
            setTitleColor(Theme.Colors.whiteText, for: .normal)
            backgroundColor = Theme.Colors.greenText
            cornerRadius = 10
            botLeftRadius = 30
        case .checkBox:
            setTitleColor(Theme.Colors.goldText, for: .selected)
            backgroundColor = Theme.Colors.redText
            clipsToBounds = true
            
            titleLabel?.font = UIFont.fontAwesome(ofSize: .font12, weight: .solid)
            setTitle("check", for: .selected)
            addTarget(self, action: #selector(selectionChanged), for: .touchUpInside)
            borderColor = Theme.Colors.whiteText
            borderWidth = 2
            cornerRadius = 5
        case .radioButton:
            setTitleColor(Theme.Colors.goldText, for: .selected)
            backgroundColor = Theme.Colors.redText
            clipsToBounds = true
            
            titleLabel?.font = UIFont.fontAwesome(ofSize: .font12, weight: .solid)
            setBackgroundImage(UIImage(named: "radio_button_unselected"), for: .normal)
            setBackgroundImage(UIImage(named: "radio_button_selected"), for: .selected)
            addTarget(self, action: #selector(selectionChanged), for: .touchUpInside)
        }
    }
    
    @objc fileprivate func selectionChanged(){
        isSelected = !isSelected
    }
    
}

extension APButton {
    func setStyle(_ buttonStyle: ButtonStyle) {
        self.buttonStyle = buttonStyle
        self.customization()
    }
    @IBInspectable var setStyle:Int {
        set {
            setStyle(ButtonStyle(rawValue: newValue) ?? ButtonStyle.simple)
        }
        get {
            return self.buttonStyle.rawValue
        }
    }
}

@objc enum ButtonStyle:Int {
    case simple         = 0
    case `default`      = 1
    case green          = 2
    case default30      = 3
    case default1030    = 4
    case checkBox       = 5
    case radioButton    = 6
    
    var value:Int {
        return self.rawValue
    }
}
