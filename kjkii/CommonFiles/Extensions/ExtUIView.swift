//
//  Sharjah Book Festival
//
//  Created by Zuhair Hussain on 28/02/2018.
//  Copyright © 2018 Zuhair Hussain. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            //layer.masksToBounds = newValue > 0
            clipsToBounds = newValue > 0
        }
    }
    
    @IBInspectable var botLeftRadius: CGFloat {
        get {
            //self.layer.mask
            return 0.0 //layer.cornerRadius
        }
        set {
            let maskPath = UIBezierPath(
                roundedRect: self.bounds,
                byRoundingCorners: [.bottomLeft],
                cornerRadii: CGSize(width: newValue, height: 0.0)
            )
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    @IBInspectable var topLeftRadius: CGFloat {
        get {
            //self.layer.mask
            return 0.0 //layer.cornerRadius
        }
        set {
            let maskPath = UIBezierPath(
                roundedRect: self.bounds,
                byRoundingCorners: [.topLeft],
                cornerRadii: CGSize(width: newValue, height: 0.0)
            )
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func makeCard() {
        
        let rect = CGRect(x: -0.5, y: -0.5, width: self.frame.width + 1, height: self.frame.height + 1)
        let shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 170/255, green: 170/255, blue: 190/255, alpha: 1).cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 0.5
        
        layer.shadowRadius = 50
        layer.shadowPath = shadowPath.cgPath
        layer.cornerRadius = 30
    }
    
    // View Shake
    
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
        
    }
    
    func addShadow(yOffset:Double = 0, shadowColor:CGColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)){
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: yOffset)
    }
    
    func addShadowTabButton(){
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowRadius = 4
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    func clearShadow(){
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOpacity = 0
        self.layer.shadowRadius = 0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }    
}

extension UIView {
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
}
