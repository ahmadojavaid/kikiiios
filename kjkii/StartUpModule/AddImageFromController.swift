//
//  AddImageFromController.swift
//  kjkii
//
//  Created by abbas on 7/27/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class AddImageFromController: UIViewController {
    
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var viewBotConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Colors.windowOver
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.15) {
            self.viewBotConstraint.constant = self.optionsView.frame.size.height
            self.view.layoutSubviews()
        }
    }
    
    @IBAction func btnTaped(_ sender: Any) {
        UIView.animate(withDuration: 0.15, animations: {
            self.viewBotConstraint.constant = 0
            self.view.layoutSubviews()
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
}
