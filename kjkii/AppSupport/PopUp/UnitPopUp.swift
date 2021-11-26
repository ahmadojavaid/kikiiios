//
//  UnitPopUp.swift
//  kjkii
//
//  Created by Saeed Rehman on 22/01/2021.
//  Copyright © 2021 abbas. All rights reserved.
//

import UIKit

class UnitPopUp: UIViewController {
    var completion:((_ text:String)->Void)!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func configure(completion:@escaping (_ text:String)->Void){
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.completion = completion
    }
    @IBAction func btnCmPressed(_ sender: Any) {
        self.completion("cm")
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnFeetPressed(_ sender: Any) {
        self.completion("feet")
        self.dismiss(animated: false, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
