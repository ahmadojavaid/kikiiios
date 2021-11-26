//
//  Theme.swift
//  HireSecurity
//
//  Created by abbas on 1/30/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class Theme {
    private static let standardHeight:CGFloat = 414.0 // iPhone 11 Pro Max Width
    private static let standardHeightT:CGFloat = 896.0
    
    static func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width
    }
    static func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    private static func screenSize(_ isTrue:Bool = false) -> CGFloat {
        let h = screenHeight()
        let w = screenWidth()
        if isTrue {
            return h > w ? h:w
        } else {
            return h < w ? h:w
        }
    }
    
    static func standardRatio()->CGFloat{
        return screenSize()/standardHeight
    }
    
    static func standardRatioH()->CGFloat{
        return screenSize(true)/standardHeightT
    }
    
    static func adjustRatio(_ value:CGFloat) -> CGFloat {
        return (value * 0.75) + (value * 0.25 * standardRatio())
    }
    static func adjustRatioH(_ value:CGFloat) -> CGFloat {
        return (value * 0.5) + (value * 0.5 * standardRatioH())
    }
    
    static var standerdSpace:CGFloat = adjustRatio(10)
    static var standerdSpaceH:CGFloat = adjustRatioH(10)
    
    class Colors {
        static var tint:UIColor = redText
        static var whiteText:UIColor = #colorLiteral(red: 0.9791666667, green: 1, blue: 1, alpha: 1)
        static var backGroundP:UIColor = redText
        static var backGroundS:UIColor = lightGray
        
        static var redText:UIColor =  #colorLiteral(red: 0.8862745098, green: 0.1803921569, blue: 0.1803921569, alpha: 1)
        static var greenText:UIColor = #colorLiteral(red: 0, green: 0.4869307876, blue: 0.1440680325, alpha: 1)
        static var blueText:UIColor = #colorLiteral(red: 0.2255640626, green: 0.3386905193, blue: 0.6001682878, alpha: 1)
        static var goldText:UIColor = #colorLiteral(red: 1, green: 0.7608942389, blue: 0.2971890569, alpha: 1)
        static var darkText:UIColor = #colorLiteral(red: 0.1529411765, green: 0.1882352941, blue: 0.2666666667, alpha: 1)
        static var grayText:UIColor = #colorLiteral(red: 0.7103006795, green: 0.7254134599, blue: 0.7254134599, alpha: 1) // ??
        static var disabled:UIColor = #colorLiteral(red: 0.8312816024, green: 0.8314250112, blue: 0.8312725425, alpha: 1) // ??
        //static var placeholder:UIColor = #colorLiteral(red: 0.5999328494, green: 0.6000387073, blue: 0.5999261737, alpha: 1)
 
        static var lightGray:UIColor = #colorLiteral(red: 0.9998916984, green: 1, blue: 0.9998809695, alpha: 1) // ???
        static var primary:UIColor = redText
        static var secondry:UIColor = goldText
        static var borderColor:UIColor = disabled
        
        static var windowOver = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        //static var redBorder:UIColor = #colorLiteral(red: 0.9780651927, green: 0.4207268357, blue: 0.3205661774, alpha: 1)
        //static var lightBlue:UIColor = Colors.secondry
    }
    
    class Font {
        static func ofSize(_ size:FontSize = .font17, weight:FontWeight) -> UIFont {
            let fontName = "\(Constants.appFont)-\(weight.value)"
            let fontSize = Theme.adjustRatio(CGFloat(size.value))
            let selectedFont = UIFont.init(name: fontName, size: fontSize)
            let font = adjustNullResults(selectedFont, weight, fontSize)
            return font
        }
        
        fileprivate static func adjustNullResults(_ selectedFont: UIFont?, _ weight: FontWeight, _ fontSize: CGFloat) -> UIFont {
            if selectedFont != nil {
                return selectedFont!
            }
            print("AppFont Failed. Loading System Font...")
            if let weight = weight.sysWeight() {
                return UIFont.systemFont(ofSize: fontSize, weight: weight)
            }
            return UIFont.italicSystemFont(ofSize: fontSize)
        }
    }
}

extension FontWeight {
    func sysWeight() -> UIFont.Weight? {
        switch self {
        case .hairline, .thin, .light:
            return UIFont.Weight.light
        case .regular:
            return UIFont.Weight.regular
        case .medium, .semiBold:
            return UIFont.Weight.medium
        case .bold:
            return UIFont.Weight.bold
        case .heavy:
            return UIFont.Weight.heavy
        case .black:
            return UIFont.Weight.black
        default:
            return nil
        }
    }
}
