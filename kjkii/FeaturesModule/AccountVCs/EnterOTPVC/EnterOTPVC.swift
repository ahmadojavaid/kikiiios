//
//  EnterOTPVC.swift
//  kjkii
//
//  Created by Shahbaz on 08/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import KRProgressHUD
import CoreLocation
import FirebaseAuth
class EnterOTPVC: UIViewController,AuthUIDelegate {
    
    @IBOutlet weak var text1: UITextField!
    @IBOutlet weak var text2: UITextField!
    @IBOutlet weak var text3: UITextField!
    @IBOutlet weak var text4: UITextField!
    @IBOutlet weak var text5: UITextField!
    @IBOutlet weak var text6: UITextField!
    var verificationID      = String()
    var phone               = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func text1Changed(_ sender: UITextField) {
        let text = sender.text!
        if text.count == 1{
            text2.becomeFirstResponder()
        }
    }
    @IBAction func text2Changed(_ sender: UITextField) {
        let text = sender.text!
        if text.count == 1{
            text3.becomeFirstResponder()
        }
        else if text.count == 0{
            text1.becomeFirstResponder()
        }
    }
    
    @IBAction func text3Changed(_ sender: UITextField) {
        let text = sender.text!
        if text.count == 1{
            text4.becomeFirstResponder()
        }
        else if text.count == 0{
            text2.becomeFirstResponder()
        }
    }
    @IBAction func text4Changed(_ sender: UITextField) {
        let text = sender.text!
        if text.count == 1{
            text5.becomeFirstResponder()
        }
        else if text.count == 0{
            text3.becomeFirstResponder()
        }
    }
    
    @IBAction func text5Changed(_ sender: UITextField) {
        let text = sender.text!
        if text.count == 1{
            text6.becomeFirstResponder()
        }
        else if text.count == 0{
            text4.becomeFirstResponder()
        }
    }
    @IBAction func text6Changed(_ sender: UITextField) {
        let text = sender.text!
        if text.count == 1{
            verify()
        }
        else if text.count == 0{
            text5.becomeFirstResponder()
        }
    }
    
    @IBAction func resendBtnPressed(_ sender: Any) {
        sendCode(phoneNumber: phone)
    }
    
    func sendCode(phoneNumber:String)
    {
        KRProgressHUD.showMessage("Please Wait.. ")
        sendCodeAfterVerificiation(trimmed: phoneNumber) { [weak self] (done) in
            guard let self = self else {return }
            if done{
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterOTPVC") as! EnterOTPVC
//                vc.verificationID = self.verificationID
//                vc.phone = phoneNumber
//                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func sendCodeAfterVerificiation(trimmed: String, completion : @escaping (_ done: Bool)-> Void)
    {
        PhoneAuthProvider.provider().verifyPhoneNumber(trimmed, uiDelegate: self) { [unowned self] (verificationID, error) in
            if error != nil
            {
                print("eror: \(error?.localizedDescription)")
                KRProgressHUD.dismiss()
                self.alert(message: "Could not send code, please try later")
                completion(false)
            }
            else
            {
                
                KRProgressHUD.dismiss()
                self.verificationID = verificationID!
                completion(true)
            }
        }
    }
    
    
    func verify(){
        var code = text1.text! + text2.text! + text3.text! + text4.text! + text5.text!
        code = code + text6.text!
        
        KRProgressHUD.show(withMessage: "Please Wait.....")
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationID, verificationCode: code)
        Auth.auth().signIn(with: credential) { [unowned self] (user, error) in
            
            
            
            if error != nil
            {
                KRProgressHUD.dismiss()
                print("Wrong Code...")
            }
            else
            {
                if let id = user?.user.uid{
                    DEFAULTS.setValue(id, forKey: "FBID")
                }
                KRProgressHUD.dismiss()
                let serverCall = SendOTP(phone: phone)
                serverCall.send { [unowned self](result) in
                    switch result{
                    case .success(let data):
                        if data.success ?? false == true{
                            
                            if data.user?.name == nil{
                                UIHelper.shared.saveUserData(user: data.user!)
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterNameVC") as! EnterNameVC
                                vc.loginType = .phone
                                self.navigationController?.pushViewController(vc, animated: true)
                            }else if data.user?.profile_pic == nil{
                                UIHelper.shared.saveUserData(user: data.user!)
                                let vc = self.storyboard?.instantiateViewController(identifier: "AddImageController") as! AddImageController
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            
                            else{
                                UIHelper.shared.saveUserData(user: data.user!)
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! MainTabBarController
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            
                        }
                        else{
                            self.alert(message: data.message ?? API_ERROR)
                        }
                    case .failure(let error):
                        self.alert(message: error.rawValue)
                    }
                }
                
                
                //                if Common.shared.checkLocation()
                //                {
                //                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterNameVC") as! EnterNameVC
                //                    vc.loginType = .phone
                //                    self.navigationController?.pushViewController(vc, animated: true)
                //                }
                //                else{
                //                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnableLocation") as! EnableLocation
                //                    self.navigationController?.pushViewController(vc, animated: true)
                //                }
                
            }
        }
        
        
        //        let verifyCode = VerifyCode(code: code)
        //        verifyCode.verifyCode {[unowned self] (result) in
        //            switch result {
        //            case .success(let data):
        //                proceedNext(data: data)
        //            case .failure(let error):
        //                self.alert(message: error.rawValue)
        //            }
        //        }
    }
    
    
    func proceedNext(data: VerifyCodeResponse){
        if data.success ?? false
        {
            UIHelper.shared.saveUserData(user: data.data!.user!)
            if Common.shared.checkLocation()
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnterNameVC") as! EnterNameVC
                vc.loginType = .phone
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "EnableLocation") as! EnableLocation
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else{
            alert(message: data.message ?? API_ERROR)
        }
    }
    
    
    
}
