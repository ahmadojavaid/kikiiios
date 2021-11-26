//
//  SocialVc.swift
//  kjkii
//
//  Created by Saeed Rehman on 25/01/2021.
//  Copyright © 2021 abbas. All rights reserved.
//

import UIKit

class SocialVc: UIViewController {
    var completion:((_ text:String)->Void)!
    @IBOutlet weak var titletxt: UILabel!
    @IBOutlet weak var socialUrl: UITextField!
    var title_string = String()
    var oldText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if title_string == "insta"{
            titletxt.text = "Enter Instagram Username"
            
        }else if title_string == "fb"{
            titletxt.text = "Enter Facebook Username"
        }else{
            titletxt.text = "Enter TikTok Username"
        }
        if oldText != ""{
            socialUrl.text = oldText
        }
       
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
    @IBAction func btnSavePressed(_ sender: Any) {
//        let myurl = socialUrl.text!
        
//        if isValidUrl(url: myurl){
            self.completion(socialUrl.text!)
            self.dismiss(animated: false, completion: nil)
//        }else{
//            self.alert(message: "please enetr username")
//        }
        
        
        
        
        
//        if myurl.isEmpty{
//            self.alert(message: "please enetr url")
//        }else{
//            self.completion(socialUrl.text!)
//            self.dismiss(animated: false, completion: nil)
//        }
        
    }
    
    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
}

