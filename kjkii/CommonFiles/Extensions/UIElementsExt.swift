//
//  UIElementsExt.swift
//  Movies
//
//  Created by Zuhair on 2/17/19.
//  Copyright © 2019 Zuhair Hussain. All rights reserved.
//

import UIKit

extension UIScreen {
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
}

extension UITableView {
    func addRefreshControl(_ target: Any, selector: Selector) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(target, action: selector, for: .valueChanged)
        refreshControl.backgroundColor = UIColor.clear
        self.refreshControl = refreshControl
    }
}

extension Array where Element: UIView {
    func index(of view: UIView) -> Int? {
        for (index, value) in self.enumerated() {
            if value == view {
                return index
            }
        }
        return nil
    }
}
