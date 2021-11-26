//
//  SelectLanguage.swift
//  kjkii
//
//  Created by Saeed Rehman on 22/01/2021.
//  Copyright © 2021 abbas. All rights reserved.
//

import UIKit
class SelectLanguage: UIViewController {
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
    
    @IBAction func btnLangPressed(_ sender: Any) {
        self.completion("English")
        self.dismiss(animated: false, completion: nil)
    }
    
    
}
