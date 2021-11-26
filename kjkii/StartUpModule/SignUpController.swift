//
//  SignUpController.swift
//  kjkii
//
//  Created by abbas on 7/26/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func facebookBtnPressed(_ sender: Any) {
        handleCustomFBLogin()
    }
    
    @objc func handleCustomFBLogin() {
        showProgress(sender: self)
        let facebookMangager = SocialMediaManager()
        facebookMangager.facebookSignup(self)
        facebookMangager.successBlock = {[unowned self] (response) -> Void in
            dismisProgress()
            let a = response as! Dictionary<String, String>
            let em         = a["data[User][email]"]!
            let last_name  = a["data[User][last_name]"]!
            let first_name = a["data[User][first_name]"]!
            let id         = a["data[User][facebook_id]"]!
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterNameVC") as! EnterNameVC
            vc.userEmail    = em
            vc.loginType    = .facebook
            vc.id           = id
            vc.userName     = first_name + " " + last_name
            self.navigationController?.pushViewController(vc, animated: true)

        }
    }
}
