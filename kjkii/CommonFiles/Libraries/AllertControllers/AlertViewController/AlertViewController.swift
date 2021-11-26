//
//  AlertViewController.swift
//  BoothBook
//
//  Created by abbas on 27/11/2019.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class AlertViewController: BaseViewController {
     
    @IBOutlet weak var circularView: UIView!
    
    @IBOutlet weak var btnAction: UIButton!
    
    @IBOutlet weak var lblText: UILabel!
    
    var completion:(()->Void)?
    var message:String = "Payment Unsuccessful!"
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(message:String, completion: (() -> Void)?) {
        self.init(nibName: "AlertViewController", bundle: .main)
        setData(message: message, completion: completion)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0.1, alpha: 0.6)
        //buttonHeight.constant = 42 * 0.75 + 42 * 0.25 * Theme.standardRatio()
        self.lblText.text = message
    }
    
    @IBAction func btnAction(_ sender: Any) {
        if let completion = completion {
            completion()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setData (message:String, completion:(()->Void)?){
        self.message = message
        self.completion = completion
    }
}
