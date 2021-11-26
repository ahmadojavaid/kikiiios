//
//  AttendenEvent.swift
//  kjkii
//
//  Created by Shahbaz on 20/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation
struct AttendenEvent : Codable {
    var id = String()
    func attend(){
        let url = URL(string: EndPoints.BASE_URL + "attend/event")
    }
}
