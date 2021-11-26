//
//  EditBioVC.swift
//  kjkii
//
//  Created by Shahbaz on 06/11/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import GrowingTextView

class EditBioVC: UIViewController {
    @IBOutlet weak var bioText: GrowingTextView!
    var delegate : EditBio?
    
    var myBio = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        UIHelper.shared.popView(sender: self)
        bioText.text = myBio
    }
    @IBAction func backBtnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        delegate?.bioChanged(text: bioText.text!)
        self.navigationController?.popViewController(animated: true)
    }
    
}


protocol EditBio {
    func bioChanged(text: String)
}
