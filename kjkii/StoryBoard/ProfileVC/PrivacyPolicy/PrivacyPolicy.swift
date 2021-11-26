//
//  PrivacyPolicy.swift
//  kjkii
//
//  Created by Saeed Rehman on 18/01/2021.
//  Copyright © 2021 abbas. All rights reserved.
//

import UIKit

class PrivacyPolicy: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backBtnTpd(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
