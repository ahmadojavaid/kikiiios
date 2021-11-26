//
//  AppDelegateSceneDelegate.swift
//  HireSecurity
//
//  Created by abbas on 1/22/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

extension AppDelegate {
    static var shared:AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
}
