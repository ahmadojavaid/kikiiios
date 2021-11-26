//
//  UITableCollectionCellExtension.swift
//  PROXX
//
//  Created by abbas on 1/9/20.
//  Copyright © 2020 SSA Soft. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static func getInstance(nibName:String) -> UITableViewCell? {
        if let nibContents = Bundle.main.loadNibNamed(nibName, owner: UITableViewCell(), options: nil) {
            for item in nibContents {
                if let cell = item as? UITableViewCell {
                    return cell
                }
            }
        }
        return nil
    }
}
