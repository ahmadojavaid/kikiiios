//
//  TextPickerViewController.swift
//  PROXX
//
//  Created by abbas on 12/23/19.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class TextPickerViewController: UIViewController {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var textField: UITextField!
    var completion:((_ text:String)->Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configure(completion:@escaping (_ text:String)->Void){
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.completion = completion
    }
    
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnAddPressed(_ sender: Any) {
        completion(textField.text ?? "")
        self.dismiss(animated: false, completion: nil)
    }
    
}
