//
//  FiltersController.swift
//  kjkii
//
//  Created by abbas on 7/29/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class FiltersController: UIViewController {
    
    @IBOutlet weak var tableVeiw: UITableView!
    var isUpgraded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableVeiw.delegate = self
        tableVeiw.dataSource = self
        tableVeiw.separatorStyle = .none
        tableVeiw.allowsSelection = false
        


        
        tableVeiw.register(UINib(nibName: "FiltersCell", bundle: .main), forCellReuseIdentifier: "FiltersCell")
        tableVeiw.register(UINib(nibName: "TableViewCell", bundle: .main), forCellReuseIdentifier: "TableViewCell")
        tableVeiw.register(UINib(nibName: "TableCollectionCell", bundle: .main), forCellReuseIdentifier: "TableCollectionCell")
    }
    
    @objc func btnUpgradePressed(_ sender:UIButton) {
        isUpgraded = true
        tableVeiw.reloadData()
    }
}

extension FiltersController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersCell") as! FiltersCell
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
            cell.setData(target:self, selector:#selector(btnUpgradePressed(_:)), isHidden:isUpgraded)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCollectionCell") as! TableCollectionCell
        cell.isUpgraded = isUpgraded
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < 2 {
            return tableView.rowHeight
        }
        return 600
    }
}

