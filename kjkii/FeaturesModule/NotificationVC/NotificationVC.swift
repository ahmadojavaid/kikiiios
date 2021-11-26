//
//  NotificationVC.swift
//  kjkii
//
//  Created by Shahbaz on 09/11/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var containerview: UIView!
    @IBOutlet weak var tblView: UITableView!
    var notificationList = [NotificationsNew]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(UINib(nibName: "NotificationsCell", bundle: nil), forCellReuseIdentifier: "NotificationsCell")
        tblView.delegate    = self
        tblView.dataSource = self
        tblView.rowHeight = 100
        UIHelper.shared.addBanners(container: containerview, sender: self)
//        getNotifications()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getSingleEvent()
    }
    
//    func getNotifications(){
//        showProgress(sender: self)
//        let url = EndPoints.BASE_URL + "notifications"
//
//        let param = ["":""]
//        getWebCallWithTokenWithCodeAble(url: url, params: param, webCallName: "", sender: self) { (response, error) in
//            dismisProgress()
//            if !error{
//
//                let data = response.data(using: .utf8)!
//                do
//                {
//                    self.notificationList.removeAll()
//                    let response = try JSONDecoder().decode(NotificationStruct.self, from: data)
//                    if let  notification = response.notifications {
//                        self.notificationList.append(contentsOf: notification)
//                        self.tblView.reloadData()
//                    }
//
//                    else{
//                        self.alert(message: error.description)
//                    }
//
//
//                }
//                catch (let error){
//                    print(error.localizedDescription)
//                }
//
//
//
//
//
//            }else{
//                self.alert(message: API_ERROR)
//            }
//        }
//    }
    func getSingleEvent(){
        let url = EndPoints.BASE_URL + "notifications"
        let finalURL = URL(string:url)!
        
        let logindata = [
                          
               "id": "" ,
               
                   ] as [String : String]

        getSinglePostData(param: logindata, url: finalURL, onSuccess: { [self] (status, msg, res) in
              
//              let parseRes = ApiManager.responseParsingOrderHistory(result: res)
            
//            self.OrdersData = parseRes
            
           let jsonString = jsonToString(jsonTOConvert: res)
             let jsonData = jsonString.data(using: .utf8)
            
            let blogPosts: NotificationModel = try! JSONDecoder().decode(NotificationModel.self, from: jsonData!)
          print(blogPosts)
           let item = blogPosts.notifications
            self.notificationList.append(contentsOf: item!)
            
            
            tblView.delegate    = self
            tblView.dataSource  = self
            tblView.reloadData()
            
            
            
            
         }) { (status, msg, res) in
             
           
                
                 print("DO NOT RESET PRESCRIPTION COMMAND FROM PRESCRIPTION VC")
               
            
             print(res)
         }
       
    }
    func jsonToString(jsonTOConvert: AnyObject) -> String{
        do {
            let data =  try JSONSerialization.data(withJSONObject: jsonTOConvert, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let convertedString = String(data: data, encoding: String.Encoding.utf8) {
                return convertedString
            }
        } catch let myJSONError {
            print(myJSONError)
        }
        return ""
    }
}



extension NotificationVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell") as! NotificationsCell
        let item = notificationList[indexPath.row]
        UIHelper.shared.setImage(address: item.profile_pic ?? "", imgView: cell.notiImage)
        cell.notiTxt.text = item.body
//        cell.notiTime.text = item.created_at
        
        UIHelper.shared.setCell(cell: cell)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if notificationList[indexPath.row].type != "audio" && notificationList[indexPath.row].type != "video" && notificationList[indexPath.row].type != "missed_call" {
        if notificationList[indexPath.row].type == "match"{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "YourMatchVC") as! YourMatchVC
            vc.comeFromNoti = true
           navigationController?.pushViewController(vc, animated: true)
        }else{
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let home = storyBoard.instantiateViewController(withIdentifier: "CommunityDetailVC") as! CommunityDetailVC
        
        let postID = String(notificationList[indexPath.row].post_id ?? 0)
        home.singlePostID = postID
        home.comefromDeepLink = true
        navigationController?.pushViewController(home, animated: true);
        }
        }
    }
    
    
}
