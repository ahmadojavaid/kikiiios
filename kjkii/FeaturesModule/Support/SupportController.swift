//
//  SupportController.swift
//  kjkii
//
//  Created by abbas on 8/29/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import Firebase


class SupportController: UIViewController {
    
    @IBOutlet weak var btnLogout: APButton!
    @IBOutlet weak var tableVeiw: UITableView!
    var mData = ["KiKii Support", "Report A Problem", "Terms & Conditions", "Privacy Policy", "Account", "Upgrade Account", "Request Account Deletion", "Blocked Profiles", "Language", "Units", "V 1.1.0"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIHelper.shared.popView(sender: self)
        btnLogout.customize(font: .font24, .bold, .redText, for: .normal)
        tableVeiw.delegate = self
        tableVeiw.dataSource = self
        tableVeiw.separatorStyle = .none
        tableVeiw.allowsSelection = false
        tableVeiw.backgroundColor = .clear
        tableVeiw.register(UINib(nibName: "SupportHCell", bundle: .main), forCellReuseIdentifier: "SupportHCell")
        tableVeiw.register(UINib(nibName: "SupportCell", bundle: .main), forCellReuseIdentifier: "SupportCell")
    }
    
    @IBAction func backBtnTpd(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func alertWithAction(message:String){
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)

        // Create the actions
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.restartApplication()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }

        // Add the actions
        alertController.addAction(okAction)
//        alertController.addAction(cancelAction)

        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    func restartApplication () {
        do
        {
            try Auth.auth().signOut()
        }
        catch let error as NSError
        {
            print (error.localizedDescription)
        }
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let navCtrl = stb.instantiateViewController(withIdentifier: "root") as! UINavigationController
        
        guard
            let window = UIApplication.shared.keyWindow,
            let rootViewController = window.rootViewController
        else {
            return
        }
        navCtrl.view.frame = rootViewController.view.frame
        navCtrl.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = navCtrl
        })
        
    }
   
}


extension SupportController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0, 4, mData.count - 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SupportHCell") as! SupportHCell
            cell.setData(text: mData[indexPath.row], type: indexPath.row == mData.count - 1 ? .center:.default)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SupportCell") as! SupportCell
            cell.label.text = mData[indexPath.row]
            cell.mainBtn.tag = indexPath.row - 1
            cell.mainBtn.addTarget(self, action: #selector(mainBtnPressed(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    @objc func mainBtnPressed(_ sender:UIButton){
        let index = sender.tag
        print(index)
                switch index {
                case 0:
                   
                    let vc = UserReportVC(nibName: "UserReportVC", bundle: nil)
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                case 1:
                    let stb = UIStoryboard(name: "Main", bundle: nil)
                    let vc = stb.instantiateViewController(withIdentifier: "TermsAndConditions") as! TermsAndConditions
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                case 2:
                    let stb = UIStoryboard(name: "Main", bundle: nil)
                    let vc = stb.instantiateViewController(withIdentifier: "PrivacyPolicy") as! PrivacyPolicy
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                case 3:
                    print("Account")
                    return
                case 4:
                    print("Upgrade Acoount")
                    let stb = UIStoryboard(name: "Main", bundle: nil)
                        let vc = stb.instantiateViewController(withIdentifier: "SubscriptioVC") as! SubscriptioVC
                     vc.hidesBottomBarWhenPushed     = true
                   self.navigationController?.pushViewController(vc, animated: true)
                   
                    return
                case 5:
                    print("request deletion")
                    deleteAccount()
                    return
                case 6:
                    print(index)
                    let stb = UIStoryboard(name: "Main", bundle: nil)
                    let vc = stb.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                case 7:
                    print("Language")
                    let vc = SelectLanguage(nibName: "SelectLanguage", bundle: .main)
                    vc.configure { (text) in
                        print(text)
                        
                    }
                    self.present(vc, animated: true, completion: nil)
                    return
                default:
                    print("units")
                    let vc = UnitPopUp(nibName: "UnitPopUp", bundle: .main)
                    vc.configure { (text) in
                        print(text)
                        DEFAULTS.setValue(text, forKey: "units")
                    }
                    self.present(vc, animated: true, completion: nil)
                    return
                }
        
    }
    
    func deleteAccount(){
        let url = EndPoints.BASE_URL + "delete/account/" + "\(CurrentUser.userData()!.id!)"
        let param = ["":""]
        deleteWebCall(url: url, params: param, webCallName: "", sender: self) { (response, error) in
            if !error{
//                self.alert(message: "\(response["message"])")
                
                self.alertWithAction(message: "Your request for account deletion has been submitted")
                
            }else{
                self.alert(message: API_ERROR)
            }
        }
    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0, 4, mData.count - 1:
            return print(indexPath.row)
        default:
            return print(indexPath.row)
        }
        
        
        
        
        
//        print(indexPath.row)
//        switch indexPath.row {
//        case 0:
//            print("0")
//            print(indexPath.row)
//        case 1:
//            print(indexPath.row)
//            let stb = UIStoryboard(name: "Main", bundle: nil)
//            let vc = stb.instantiateViewController(withIdentifier: "TermsAndConditions") as! TermsAndConditions
//            self.navigationController?.pushViewController(vc, animated: true)
//        case 2:
//            print(indexPath.row)
//            let stb = UIStoryboard(name: "Main", bundle: nil)
//            let vc = stb.instantiateViewController(withIdentifier: "PrivacyPolicy") as! PrivacyPolicy
//            self.navigationController?.pushViewController(vc, animated: true)
//        default:
//            print("not")
//        }
    }
}


