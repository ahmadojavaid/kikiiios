//
//  AlertViewControllerTwo.swift
//  PROXX
//
//  Created by abbas on 12/27/19.
//  Copyright © 2019 SSA Soft. All rights reserved.
//

import UIKit

class AlertViewControllerTwo: UIViewController {

    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnCloseWidth: NSLayoutConstraint!

    
    var completionLeft:(()->Void)?
    var completionRight:(()->Void)?
    
    var data:AlertVCData = AlertVCData()
    
    convenience init(data:AlertVCData?, completionLeft:(()->Void)?, completionRight:(()->Void)?) {
        self.init(nibName: "AlertViewControllerTwo", bundle: .main)
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
        
        if let data = data {
            self.data = data
        }
        self.completionLeft = completionLeft
        self.completionRight = completionRight
    }
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0.1, alpha: 0.6)
        
        self.lblText.text = data.message
        if !data.isCloseBtn {
            self.btnCloseWidth.constant = 25
            self.btnClose.isHidden = true
        }
        self.btnLeft.setTitle(data.btnLefttext, for: .normal)
        self.btnRight.setTitle(data.btnRighttext, for: .normal)
        //buttonHeight.constant = 42 * 0.75 + 42 * 0.25 * Theme.standardRatio()
    }
    
    @IBAction func btnLeftPressed(_ sender: Any) {
        completionLeft?()
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func btnRightPressed(_ sender: Any) {
        completionRight?()
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

struct AlertVCData {
    var message = "Are you sure you want to\nLog out?"
    var btnLefttext = "Yes"
    var btnRighttext = "No"
    var isCloseBtn:Bool = false
}
