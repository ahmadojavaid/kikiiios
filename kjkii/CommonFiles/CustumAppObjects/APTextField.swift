//
//  APTextFieldUI.swift
//  TheICERegister
//
//  Created by abbas on 5/22/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
class APTextField: UITextField {
    
    var color: TextColors = .darkText
    var weight: FontWeight = .medium
    var size: FontSize! = .font17
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.customization()
        defaultLeftViews()
        defaultRightViews()
        delegate = self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customization()
        defaultLeftViews()
        defaultRightViews()
        delegate = self
    }
    
    convenience init(fontSize:FontSize, color:TextColors = .darkText, weight:FontWeight = .regular, rView:UIView? = nil, lView:UIView? = nil ) {
        self.init(frame: CGRect())
        customize(fontSize, weight, color)
        setRLDView(rView, lView)
    }
    
    func customize(_ fontSize: FontSize, _ weight: FontWeight, _ color: TextColors) {
        self.size = fontSize
        self.weight = weight
        self.color = color
        customization()
    }
    
    func setRLViews(_ rView: UIView?, _ lView: UIView?) {
        if let rView = rView {
            rightView = rView
            rightViewMode = .always
        }
        if let lView = lView {
            leftView = lView
            leftViewMode = .always
        }
    }
    
    fileprivate func setRLDView(_ rView: UIView?, _ lView: UIView?) {
        if let rView = rView {
            rightView = rView
            rightViewMode = .always
        }
        if let lView = lView {
            leftView = lView
            leftViewMode = .always
        } else { defaultLeftViews() }
    }
    
    fileprivate func defaultLeftViews() {
        let lView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 40))
        leftView = lView
        leftViewMode = .always
    }
    
    fileprivate func defaultRightViews() {
        let rView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 40))
        rightView = rView
        rightViewMode = .always
    }
    
    fileprivate func customization(){
        translatesAutoresizingMaskIntoConstraints = false
        font = Theme.Font.ofSize(self.size, weight: self.weight)
        textColor = self.color.value
        tintColor = Theme.Colors.tint
        backgroundColor = .clear
        cornerRadius = 10
        borderWidth = 1
        borderColor = Theme.Colors.redText
        //Theme.Colors.whiteText
        //borderStyle = .none
        
        addShadow(yOffset: 0.5, shadowColor: Theme.Colors.darkText.cgColor)
        //textAlignment = .right
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.setRoundCorners()
    }
    
    func setRoundCorners(){
        //layer.cornerRadius = self.frame.size.height / 2
        layer.cornerRadius = 10
    }
}


extension APTextField {
    
    @IBInspectable var setWeight:String {
        set {
            self.weight = FontWeight(rawValue: newValue.lowercased()) ?? FontWeight.regular
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
    
    @IBInspectable var AtPlaceholder:String {
        get {
            return self.attributedPlaceholder?.string ?? ""
        }
        set {
            let pHolder = NSAttributedString(string: newValue, attributes: [
                NSAttributedString.Key.font:Theme.Font.ofSize(.font17, weight: .italic),
                NSAttributedString.Key.foregroundColor:Theme.Colors.grayText
            ])
            self.attributedPlaceholder = pHolder
        }
    }
}

extension APTextField:UITextFieldDelegate{
/*    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.textAlignment = .left
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.textAlignment = .right
            self.layoutSubviews()
        }
    }
 */
}

/*
enum TextFieldType:Int {
    case simple
    case `default`
    case `disabled`
    
}
*/
