//
//  ExtUIFont.swift
//  TheICERegister
//
//  Created by abbas on 5/22/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
extension UIFont {
    class func fontAwesome(ofSize size:FontSize, weight:FontOwsomeWeight = .regular) -> UIFont {
        
        let fontSize = Theme.adjustRatio(CGFloat(size.value))
        let fontName = "FontAwesome5Pro-\(weight.value)"
        
        return UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    enum FontOwsomeWeight:String {
        case solid, light, regular
        var value:String{
            return self.rawValue.capitalized
        }
    }
    /*
    == FontAwesome5Pro-Solid
    == FontAwesome5Pro-Light
    == FontAwesome5Pro-Regular
    */
}
