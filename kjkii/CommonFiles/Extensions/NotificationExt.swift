//
//  Notifications.swift
//  Movies
//
//  Created by Zuhair on 2/17/19.
//  Copyright © 2019 Zuhair Hussain. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let NetworkDidConnect = Notification.Name("NetworkDidConnect")
    static let NetworkDidDisconnect = Notification.Name("NetworkDidDisconnect")
    static let BookingsListDidSet = Notification.Name("BookingsListDidSet")
    
    static let TabFollowDidSelect = Notification.Name("TabFollowDidSelect")
    static let TabPortfolioDidSelect = Notification.Name("TabPortfolioDidSelect")
    static let TabProfileDidSelect = Notification.Name("TabProfileDidSelect")
}
