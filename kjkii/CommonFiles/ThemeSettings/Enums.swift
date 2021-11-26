//
//  Enums.swift
//  Movies
//
//  Created by Zuhair on 2/17/19.
//  Copyright © 2019 Zuhair Hussain. All rights reserved.
//

import UIKit

enum NetworkStatus {
    case connected, disconnected
}

enum ToastType {
    case `default`, error, success
    
    var color: UIColor {
        switch self {
        case .default:
            return Theme.Colors.grayText
        case .error:
            return Theme.Colors.redText
        case .success:
            return Theme.Colors.secondry
        }
    }
}

enum ErrorMessages: String {
    case noNetwork = "Internet connection appears offline"
    case unknown = "Unable to communicate"
    case invalidRequest = "Invalid request"
    case invalidResponse = "Invalid response"
    case success = "Request completed successfully"
    case unauthenticated = "Unauthenticated"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

enum AnimationType {
    case fadeIn, fadeOut
}

/*
== Lato-Hairline
== Lato-Thin
== Lato-Light
== Lato-Regular
== Lato-Medium
== Lato-Semibold
== Lato-Bold
== Lato-Heavy
== Lato-Black
//////////////////////
== Lato-HairlineItalic
== Lato-ThinItalic
== Lato-LightItalic
== Lato-Italic
== Lato-MediumItalic
== Lato-SemiboldItalic
== Lato-BoldItalic
== Lato-HeavyItalic
== Lato-BlackItalic

 */
enum FontWeight:String {
    case hairline , thin, light, regular, medium, semiBold, bold, heavy, black
    case hairlineItalic , thinItalic, lightItalic, italic, mediumItalic, semiBoldItalic, boldItalic, heavyItalic, blackItalic
    var value:String {
        switch self {
        case .semiBold:
            return "semibold"
        case .semiBoldItalic:
            return "semiboldItalic"
        default:
            return self.rawValue.capitalized
        }
    }
}

enum FontSize:Int {
    
    case font96 = 96, font50 = 50, font45 = 45, font36 = 36, font30 = 30, font28 = 28, font26 = 26, font24 = 24, font22 = 22, font20 = 20, font18 = 18, font17 = 17, font16 = 16, font15 = 15, font14 = 14, font13 = 13, font12 = 12, font10 = 10, font8 = 8
    
    var value:Int {
        return self.rawValue
    }
    
}

enum TextColors:String {
    case tint, backGroundP, backGroundS
    case whiteText, redText, greenText, blueText, goldText, darkText, grayText
    case disabled, lightGray, borderColor, primary, secondry, windowOver
    
    var value:UIColor {
        switch self {
        case .tint:         return Theme.Colors.tint
        case .backGroundP:  return Theme.Colors.backGroundP
        case .backGroundS:  return Theme.Colors.backGroundS
        case .whiteText:    return Theme.Colors.whiteText
        case .redText:      return Theme.Colors.redText
        case .greenText:    return Theme.Colors.greenText
        case .blueText:     return Theme.Colors.blueText
        case .goldText:     return Theme.Colors.goldText
        case .darkText:     return Theme.Colors.darkText
        case .grayText:     return Theme.Colors.grayText
        case .disabled:     return Theme.Colors.disabled
        case .lightGray:    return Theme.Colors.lightGray
        case .borderColor:  return Theme.Colors.borderColor
        case .primary:      return Theme.Colors.primary
        case .secondry:     return Theme.Colors.secondry
        case .windowOver:   return Theme.Colors.windowOver
        }
    }
    
    var raw:String {
        return self.rawValue
    }
}



//sendCodeAfterVerificiation(trimmed: phoneNumber) { [weak self] (done) in
//    guard let self = self else {return }
//    if done{
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterOTPVC") as! EnterOTPVC
//        vc.verificationID = self.verificationID
//        vc.phone = phoneNumber
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//}
