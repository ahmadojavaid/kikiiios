//
//  Extensions.swift
//  Sharjah Book Festival
//
//  Created by Zuhair Hussain on 01/03/2018.
//  Copyright © 2018 Zuhair Hussain. All rights reserved.
//

import UIKit


extension UINavigationController {
    func makeNavigationBar(transparent: Bool) {
        if transparent {
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.isTranslucent = true
            self.view.backgroundColor = .clear
        } else {
            self.navigationBar.isTranslucent = false
            self.navigationBar.tintColor = UIColor.black
            
            
            self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.layer.shadowColor = UIColor(red: 170/255, green: 170/255, blue: 190/255, alpha: 1).cgColor
            self.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            self.navigationBar.layer.shadowRadius = 8.0
            self.navigationBar.layer.shadowOpacity = 0.5
            self.navigationBar.layer.masksToBounds = false
            
            let attrs = [
                NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)
            ]
            
            UINavigationBar.appearance().titleTextAttributes = attrs
        }
    }
}


extension NSLayoutConstraint {
    func set(multiplier:CGFloat) -> NSLayoutConstraint {
        if firstItem == nil {
            return self
        }
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem!,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
