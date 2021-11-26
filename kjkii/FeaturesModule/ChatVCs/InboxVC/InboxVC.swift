//
//  InboxVC.swift
//  kjkii
//
//  Created by Shahbaz on 05/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import FirebaseDatabase

class InboxVC: UIViewController {
    
    @IBOutlet weak var containerview: UIView!
    @IBOutlet weak var tblView: UITableView!
    
    //    var online = [Online_users]()
    
    var inbox = [InboxFbMsgs]()
    var conversations = [Conversations]()
    var otherUserFBID = String()
    let userRef = Database.database().reference().child("Users")
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "tblBack")
        tblView.register(UINib(nibName: "OnlineCell", bundle: nil), forCellReuseIdentifier: "OnlineCell")
        tblView.register(UINib(nibName: "InboxCell", bundle: nil), forCellReuseIdentifier: "InboxCell")
        tblView.delegate    = self
        tblView.dataSource  = self
        tblView.backgroundColor = UIColor(named: "tblBack")
        UIHelper.shared.addBanners(container: containerview, sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getConversation()
    }
    
    
    func getConversation()
    {
        //        inbox.removeAll()
        getInboxFromFB()
        //        GetConversations.shared.getConversations { [weak self](result) in
        //            guard let self = self else {return}
        //            dismisProgress()
        //            switch result{
        //            case .success(let data):
        //                if let conversations = data.conversations{
        //                    self.conversations = conversations
        //                }
        //
        //
        ////                if let users = data.online_users{
        ////                    self.online = users
        ////                }
        ////
        ////                print("Online USer count")
        ////                print(self.online.count)
        //                self.tblView.reloadData()
        //            case .failure(let error):
        //                self.alert(message: error.rawValue)
        //            }
        //
        //
        //        }
    }
    
    
    
    
    func getInboxFromFB(){
        Database.database().reference().child("LastMessages").observe(.value) { [weak self](data) in
            guard let self = self else {return}
            self.inbox.removeAll()
            for child in data.children
            {
                let msg = child as! DataSnapshot
                let val = msg.value! as! [String:Any]
                let key = msg.key.components(separatedBy: "___")
                if key.first == DEFAULTS.string(forKey: "FBID")!
                {
                    self.inbox.append(InboxFbMsgs(userName: "", userId: key.last!, message: "\(val["message"] ?? "")", time: "\(val["time"] ?? "0.0")", img: "", id: ""))
                }
            }
            for i in 0..<self.inbox.count{
                self.userRef.observe(.value) { [weak self] (data) in
                    guard let self = self else {return}
                    for child in data.children{
                        let msg = child as! DataSnapshot
                        let val = msg.value! as! [String:Any]
                        if msg.key == self.inbox[i].userId{
                            self.inbox[i].userName  = "\(val["userName"]!)"
                            self.inbox[i].img       = "\(val["image"]!)"
                            self.inbox[i].id        = "\(val["id"]!)"
                        }
                    }
                    self.tblView.reloadData()
                }
            }
        }
        
        
        
    }
    
    
    
}

extension InboxVC : UITableViewDelegate, UITableViewDataSource{
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return 1
    //    }
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "OnlineCell") as! OnlineCell
    //        cell.backgroundColor = UIColor(named: "tblBack")
    //        //cell.onlineUsers = self.online
    //        return cell
    //    }
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 110
    //    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return inbox.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxCell") as! InboxCell
        cell.configCell(item: inbox[indexPath.row])
        cell.nextBtn.tag = indexPath.row
        cell.nextBtn.addTarget(self, action: #selector(moreActions(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.conversationID               = "\(inbox[indexPath.row].id)"
        vc.hidesBottomBarWhenPushed     = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func moreActions(_ sender: UIButton){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Delete Conversation", style: .default, handler: {
            [unowned self] action in
            
            Common.shared.getUserFBID(otherUserID: "\(inbox[sender.tag].id)") { [weak self](key) in
                guard let self = self else {return}
                self.otherUserFBID = key
                let myString = DEFAULTS.string(forKey: "FBID")! + "___" + otherUserFBID
                let otherString = otherUserFBID + "___" + DEFAULTS.string(forKey: "FBID")!
                Database.database().reference().child("Chats").child(myString).setValue(nil)
                Database.database().reference().child("LastMessages").child(myString).setValue(nil)
                print("pressed")
                print(Database.database().reference().child("Chats").child(myString))
                self.tblView.reloadData()
            }
            
            //self.deleteConversation(tag: sender.tag)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
        }))
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.sourceRect = self.view.frame
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    func deleteConversation(tag: Int){
        let url = BASE_URL + "delete/conversation/\(conversations[tag].id ?? 0)"
        let params = ["":""]
        deleteWebCall(url: url, params: params, webCallName: "Delete Conversation", sender: self) {[unowned self] (response, error) in
            if !error{
                self.getConversation()
            }
            else{
                
            }
        }
    }
}



struct InboxFbMsgs {
    var userName    = String()
    var userId      = String()
    var message     = String()
    var time        = String()
    var img         = String()
    var id          = String()
}
