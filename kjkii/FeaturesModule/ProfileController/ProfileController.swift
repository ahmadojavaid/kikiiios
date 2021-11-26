//
//  ProfileController.swift
//  kjkii
//
//  Created by abbas on 8/25/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    @IBOutlet weak var tableVeiw: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableVeiw.delegate = self
        tableVeiw.dataSource = self
        tableVeiw.separatorStyle = .none
        tableVeiw.allowsSelection = false
        
        tableVeiw.contentInsetAdjustmentBehavior = .never
        
        tableVeiw.register(UINib(nibName: "ProfileTopCell", bundle: .main), forCellReuseIdentifier: "ProfileTopCell")
        
        tableVeiw.register(UINib(nibName: "CuriosHeadingCell", bundle: .main), forCellReuseIdentifier: "CuriosHeadingCell")
        tableVeiw.register(UINib(nibName: "CuriositiesCell", bundle: .main), forCellReuseIdentifier: "CuriositiesCell")
        tableVeiw.register(UINib(nibName: "ProfileBotCell", bundle: .main), forCellReuseIdentifier: "ProfileBotCell")
    }
    
}

extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTopCell")!
            return cell
        }
        if indexPath.row == 8 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileBotCell")!
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CuriosHeadingCell")!
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CuriositiesCell") as! CuriositiesCell
        return cell
    }
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < 2 {
            return tableView.rowHeight
        }
        //return 600
    }
 */
}


