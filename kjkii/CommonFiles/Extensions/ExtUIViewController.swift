//
//  UIViewController+Extension.swift
//  Sharjah Book Festival
//
//  Created by Zuhair Hussain on 05/03/2018.
//  Copyright © 2018 Zuhair Hussain. All rights reserved.
//

import Foundation
import UIKit
//import TTGSnackbar

extension UIViewController {
    /*
    func setRoot(){
        //UIApplication.shared.connectedScenes.first?
        UIApplication.shared.keyWindow!.replaceRootViewControllerWith(self, animated: false, completion: nil)
    }
    
    func setRoot(viewController:UIViewController){
        UIApplication.shared.keyWindow!.replaceRootViewControllerWith(viewController, animated: false, completion: nil)
    }
    */
    func showAlert(message: String, leftButton: String, rightButton: String, leftCompletion: (() -> Void)? = nil, rightCompletion: (() -> Void)? = nil) {
        let alertController = AlertViewControllerTwo(data: AlertVCData(message: message, btnLefttext: leftButton, btnRighttext: rightButton, isCloseBtn: true), completionLeft: leftCompletion, completionRight: rightCompletion)
        self.present(alertController, animated: true, completion: nil)
    }
        
    func popToHome() {
        var navigationArray = self.navigationController?.viewControllers
        var i = navigationArray?.count ?? 1
        while i>2 {
            navigationArray?.remove(at: 1)
            i = i - 1
        }
        if let navigationArray = navigationArray {
            self.navigationController?.viewControllers = navigationArray
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension UIWindow {
    func replaceRootViewControllerWith(_ replacementController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        let snapshotImageView = UIImageView(image: self.snapshot())
        self.addSubview(snapshotImageView)

        let dismissCompletion = { () -> Void in // dismiss all modal view controllers
            self.rootViewController = replacementController
            self.bringSubviewToFront(snapshotImageView)
            if animated {
                UIView.animate(withDuration: 0.4, animations: { () -> Void in
                    snapshotImageView.alpha = 0
                }, completion: { (success) -> Void in
                    snapshotImageView.removeFromSuperview()
                    completion?()
                })
            }
            else {
                snapshotImageView.removeFromSuperview()
                completion?()
            }
        }
        if self.rootViewController!.presentedViewController != nil {
            self.rootViewController!.dismiss(animated: false, completion: dismissCompletion)
        }
        else {
            dismissCompletion()
        }
    }
}
