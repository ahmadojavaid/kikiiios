//
//  EnableLocation.swift
//  kjkii
//
//  Created by Shahbaz on 12/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class EnableLocation: UIViewController {
    
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @IBAction func enableLocationBtnPressed(_ sender: Any)
    {
        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
    }
    
    @objc func timerAction() {
        if Common.shared.checkLocation(){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterNameVC") as! EnterNameVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}
