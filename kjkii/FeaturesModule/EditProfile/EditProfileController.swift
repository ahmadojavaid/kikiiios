//
//  EditProfileController.swift
//  kjkii
//
//  Created by abbas on 8/29/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class EditProfileController: UIViewController {
    
    @IBOutlet weak var tableVeiw: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableVeiw.delegate = self
        tableVeiw.dataSource = self
        tableVeiw.separatorStyle = .none
        tableVeiw.allowsSelection = false
        
        tableVeiw.register(UINib(nibName: "AddPicCell", bundle: .main), forCellReuseIdentifier: "AddPicCell")
        tableVeiw.register(UINib(nibName: "IdentityCell", bundle: .main), forCellReuseIdentifier: "IdentityCell")
        tableVeiw.register(UINib(nibName: "EditProfileMidCell", bundle: .main), forCellReuseIdentifier: "EditProfileMidCell")
        tableVeiw.register(UINib(nibName: "CuriosHeadingCell", bundle: .main), forCellReuseIdentifier: "CuriosHeadingCell")
        tableVeiw.register(UINib(nibName: "TableCollectionCell", bundle: .main), forCellReuseIdentifier: "TableCollectionCell")
        
    }
    
}

extension EditProfileController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddPicCell")!
            return cell
        }
        if indexPath.row == 5 { // count - 2
            let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileMidCell")!
            return cell
        }
        if indexPath.row == 6 { // count - 1
            let cell = tableView.dequeueReusableCell(withIdentifier: "CuriosHeadingCell") as! CuriosHeadingCell
            cell.setData(title:"CURIOSITIES")
            return cell
        }
        if indexPath.row == 7 { // count
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCollectionCell") as! TableCollectionCell
            cell.isUpgraded = true
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CuriosHeadingCell") as! CuriosHeadingCell
            cell.setData(title:"IDENTITY")
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdentityCell") as! IdentityCell
        return cell
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 7 { return 500 }
        return tableView.rowHeight
     }
}


