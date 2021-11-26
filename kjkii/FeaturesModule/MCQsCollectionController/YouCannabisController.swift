//
//  YouCannabisController.swift
//  kjkii
//
//  Created by abbas on 9/18/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class YouCannabisController: MCQsCollectionController {

    override var mData: [String] {
        get {
            return super.mData
        }
        set {
            super.mData = newValue
        }
    }
    
    override func viewDidLoad() {
        mData = AppData.CANNABIS
        super.viewDidLoad()

    }

}
