//
//  SettingViewController.swift
//  kjkii
//
//  Created by Saeed Rehman on 18/01/2021.
//  Copyright © 2021 abbas. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    var mData = [Blocked_users]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.allowsSelection = false
        tableview.backgroundColor = .clear
        tableview.register(UINib(nibName: "BlockedCells", bundle: .main), forCellReuseIdentifier: "BlockedCells")
        getBlockUsers()
        // Do any additional setup after loading the view.
    }
    
    func getBlockUsers(){
        showProgress(sender: self)
        let url = EndPoints.BASE_URL + "blocked-users"
        let param = ["":""]
        getWebCallWithTokenWithCodeAble(url: url, params: param, webCallName: "", sender: self) { (response, error) in
            dismisProgress()
            if !error{
                let data = response.data(using: .utf8)!
                do
                {
                    self.mData.removeAll()
                    let response = try JSONDecoder().decode(BlockUsersStruct.self, from: data)
                    if let  posts = response.blocked_users {
                        self.mData.append(contentsOf: posts)
                        self.tableview.reloadData()
                    }
                    
                    else{
                        self.alert(message: error.description)
                    }
                    
                    
                }
                catch (let error){
                    print(error.localizedDescription)
                }
                
            }
            else{
                self.alert(message: API_ERROR)
            }
        }
    }
    
    @IBAction func backBtnTpd(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
}
extension SettingViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "BlockedCells") as! BlockedCells
        UIHelper.shared.setImage(address: mData[indexPath.row].profile_pic ?? "", imgView: cell.userImage)
        cell.username.text = mData[indexPath.row].name ?? ""
        cell.btnBlock.tag = indexPath.row
        cell.btnBlock.addTarget(self, action: #selector(unblockBtnPressed(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    @objc func unblockBtnPressed(_ sender:UIButton){
        
        unblockUser(id: "\(mData[sender.tag].id!)")
    }
    func unblockUser(id:String){
        let url = EndPoints.BASE_URL + "unblock/user"
        let param = ["id":id]
        postWebCall(url: url, params: param, webCallName: "") { (response, error) in
            if !error{
                self.getBlockUsers()
                self.alert(message: "\(response["message"])")
                
            }else{
                self.alert(message: API_ERROR)
            }
        }
        
    }
    
}

