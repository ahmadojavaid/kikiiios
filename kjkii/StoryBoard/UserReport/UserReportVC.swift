//
//  UserReportVC.swift
//  kjkii
//
//  Created by Saeed Rehman on 21/01/2021.
//  Copyright © 2021 abbas. All rights reserved.
//

import UIKit

class UserReportVC: UIViewController {
    
    @IBOutlet weak var reportMessage: UITextView!
    @IBOutlet weak var reportTitle: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        UIHelper.shared.popView(sender: self)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
      
    }
    
    @IBAction func btnsavePressed(_ sender: Any) {
        let url = EndPoints.BASE_URL + "report/problem"
        let title   = reportTitle.text!
        let message = reportMessage.text!
        let param = ["title":title,"text":message]
        postWebCall(url: url, params: param, webCallName: "") { (response, error) in
            if !error{
                oneStepBackPopUp(msg: "\(response["message"])", sender: self)
            }else{
                self.alert(message: API_ERROR)
            }
        }
    }
}
