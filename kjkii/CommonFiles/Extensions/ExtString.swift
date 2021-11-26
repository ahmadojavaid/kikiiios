//
//  StringExt.swift
//  Movies
//
//  Created by Zuhair on 2/17/19.
//  Copyright © 2019 Zuhair Hussain. All rights reserved.
//

import UIKit

extension String {
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var intValue: Int {
        return (self as NSString).integerValue
    }
    var doubleValue:Double {
        return (self as NSString).doubleValue
    }
    var cgfloatValue:CGFloat {
        return CGFloat((self as NSString).doubleValue)
    }
    var boolValue:Bool {
        return (self as NSString).boolValue
    }
    
}



