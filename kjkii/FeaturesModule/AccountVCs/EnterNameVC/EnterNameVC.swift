//
//  EnterNameVC.swift
//  kjkii
//
//  Created by Shahbaz on 12/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class EnterNameVC: UIViewController {
    @IBOutlet weak var userNameText : APTextField!
    @IBOutlet weak var userEmailText: APTextField!
    @IBOutlet weak var userBirthday : APTextField!
    @IBOutlet weak var userAgeText  : APTextField!
    
    let datePicker                  = UIDatePicker()
    
    var loginType   : LoginWith = .phone
    var userName    = String()
    var userEmail   = String()
    var id          = String()
    var dateToSend  = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameText.text           = userName
        userEmailText.text          = userEmail
        datePicker.datePickerMode   = .date
        userBirthday.inputView      = datePicker
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        if loginType == .facebook{
            userNameText.isUserInteractionEnabled   = false
            userEmailText.isUserInteractionEnabled  = false
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker){
        let df              = DateFormatter()
        df.dateFormat       = "MMM d, yyyy"
        let selectedDate    = df.string(from: sender.date)
        userBirthday.text   = selectedDate
        let years           = UIHelper.shared.yearsBetweenDate(startDate: sender.date, endDate: Date())
        userAgeText.text    = "\(years)"
        
        df.dateFormat       = "yyyy-MM-dd"
        dateToSend          = df.string(from: sender.date)
        
        
    }
    
    
    
    @IBAction func nextBtnPressed(_ sender: Any)
    {
        if loginType == .facebook{
            continueWithFacebook()
        } else if loginType == .phone{
            updateProfile()
        }
    }
    
    
    
    
    func continueWithFacebook(){
        showProgress(sender: self)
        let facebook = RegisterWithFaceBook(uid: id, email: userEmail, name: userName, birthday: dateToSend)
        facebook.register { [unowned self](result) in
            dismisProgress()
            switch result{
            case .success(let data):
                if data.success ?? false{
                    UIHelper.shared.saveUserData(user: data.user!)
                    self.gotoAddImageVC()
                }
                else{
                    self.alert(message: data.message ?? API_ERROR)
                }
            case .failure(let error):
                self.alert(message: error.rawValue)
            }
        }
    }
    
    
    func updateProfile(){
        showProgress(sender: self)
        let profile = UpdateProfile(name: userNameText.text!, email: userEmailText.text!, birthday: userBirthday.text!)
        profile.updateProfile {[unowned self] (result) in
            dismisProgress()
            switch result{
            case .success(let data):
                if data.success ?? false{
                    self.gotoAddImageVC()
                }
                else
                {
                    self.alert(message: data.message ?? API_ERROR)
                }
            case .failure(let error):
                self.alert(message: error.rawValue)
            }
        }
        
    }
    
    func gotoAddImageVC(){
        let vc = self.storyboard?.instantiateViewController(identifier: "AddImageController") as! AddImageController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


enum LoginWith{
    case facebook
    case insta
    case phone
}
