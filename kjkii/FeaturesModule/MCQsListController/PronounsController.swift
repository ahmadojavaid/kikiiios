//
//  PronounsController.swift
//  kjkii
//
//  Created by abbas on 9/18/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class PronounsController: UIViewController {

    @IBOutlet weak var lblQuestion: APLabel!
        @IBOutlet weak var tableView:UITableView!

        var mData:[String] = AppData.Your_Pronouns
        var selected:Int = -1
        
        override func viewDidLoad() {
            super.viewDidLoad()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: "OptionCell", bundle: .main), forCellReuseIdentifier: "OptionCell")
            
        }
        
        @IBAction func btnSavePressed(_ sender: Any) {
            
        }
    }

    extension PronounsController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return mData.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell") as! OptionCell
            if indexPath.row == mData.count - 1 {
                cell.setData(text: mData[indexPath.row], type: indexPath.row == selected ? .lastSelected:.last)
                return cell
            }
            cell.setData(text: mData[indexPath.row], type: indexPath.row == selected ? .selected:.default)
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: false)
            selected = indexPath.row
            tableView.reloadData()
        }
        
        
    }
