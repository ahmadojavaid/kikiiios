//
//  FontManager.swift
//  TheICERegister
//
//  Created by abbas on 5/18/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class FontManager {
    static func searchFont(keyWord:String){
        let key = keyWord.uppercased()
        for family: String in UIFont.familyNames {
            if family.uppercased().contains(key) {
                print(family)
                for names: String in UIFont.fontNames(forFamilyName: family) {
                    print("== \(names)")
                }
            }
        }
    }
}
