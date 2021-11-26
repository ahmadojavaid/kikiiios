//
//  EventDetailVC.swift
//  kjkii
//
//  Created by Shahbaz on 07/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks
import Alamofire

class EventDetailVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    var item : Event?
    var item2 : SingleEventData?
    var EventID = ""
    var comeFromLink = false
    override func viewDidLoad() {
        super.viewDidLoad()
        UIHelper.shared.popView(sender: self)
        UIHelper.shared.setupTable(nibName: "EventCell", tbl: tblView)
        UIHelper.shared.setupTable(nibName: "AddBtnCell", tbl: tblView)
        UIHelper.shared.setupTable(nibName: "PostedByCell", tbl: tblView)
        UIHelper.shared.setupTable(nibName: "AttendingCell", tbl: tblView)
        UIHelper.shared.setupTable(nibName: "ViewTicketCell", tbl: tblView)
        
        UIHelper.shared.setupTable(nibName: "DescCell", tbl: tblView)
        if comeFromLink == false{
        tblView.delegate    = self
        tblView.dataSource  = self
        }else{
            getSingleEvent()
            
            
        }
    }
    
  
    func getSingleEvent(){
        let url = BASE_URL + "event" + "?id=" + EventID
       let finalURL = URL(string:url)!
        let eventID = String(EventID)
        
        let logindata = [
                          
               "id": eventID ,
               
                   ] as [String : String]

        getSinglePostData(param: logindata, url: finalURL, onSuccess: { [self] (status, msg, res) in
              
//              let parseRes = ApiManager.responseParsingOrderHistory(result: res)
            
//            self.OrdersData = parseRes
            
           let jsonString = jsonToString(jsonTOConvert: res)
             let jsonData = jsonString.data(using: .utf8)
            
            let blogPosts: Json4Swift_Base = try! JSONDecoder().decode(Json4Swift_Base.self, from: jsonData!)
          print(blogPosts)
            item = blogPosts.event
            
            
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

extension EventDetailVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
            cell.configCell(item: item!)
            cell.clcContainerView.isHidden = true
            cell.containerHeight.constant = 0.0
            cell.imgConstraints.forEach({$0.constant = 0})
            return cell
        }
        else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddBtnCell") as! AddBtnCell
            cell.addBtn.addTarget(self, action: #selector(attendEvent), for: .touchUpInside)
            cell.shareBtn.addTarget(self, action: #selector(shareBtnPressed), for: .touchUpInside)
            return cell
        } else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostedByCell") as! PostedByCell
            cell.configCell(user: item!.user)
            return cell
        } else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttendingCell") as! AttendingCell
            cell.configCell(attendess: item!.attendants)
            self.view.layoutIfNeeded()
            return cell
        }
        //        } else if indexPath.row == 4{
        //
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "ViewTicketCell") as! ViewTicketCell
        //
        //            return cell
        //        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescCell") as! DescCell
            cell.descLabel.text = item?.eventDescription
            return cell
        }
        
        
    }
    @objc func attendEvent(){
        Common.shared.attendEvent(id: "\(item!.id)") { [unowned self](response, error) in
            if !error{
                let message = "\(response["message"])"
                self.alert(message: message)
            }
        }
    }
    @objc func shareBtnPressed(_ sender: UIButton){
        let tag = sender.tag
        let postIDValue = String(item!.id!)
        var urlToShare: URL?
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.google.com"
        components.path = "/store"
        let postIDItems = URLQueryItem(name: "event_id", value: postIDValue)
        components.queryItems = [postIDItems]
        guard let linkParameter = components.url else{return}
        print("I am sharing \(linkParameter.absoluteString)")
        let link = URL(string: "https://www.example.com/events?events_id=\(item?.id ?? 0)")
        let dynamicLinksDomainURIPrefix = "https://kikiiapp1.page.link"
       
        let linkBuilder = DynamicLinkComponents(link: linkParameter, domainURIPrefix: dynamicLinksDomainURIPrefix)
        linkBuilder!.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.jobesk.kikiiApp")
        linkBuilder?.iOSParameters?.appStoreID = "962194608"
//        linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: "com.example.android")

        guard let longDynamicLink = linkBuilder?.url else { return }
        print("The long URL is: \(longDynamicLink)")
        
        linkBuilder?.shorten(completion: { (url, warnings, error) in
                    if let error = error {
                        print("error is \(error.localizedDescription)")
                        return
                    }
                   print("The short URL is: \(String(describing: url!))")
            self.shareLink(url: url!)
            
                })
       
       
        
    }
    func shareLink(url: URL){
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(activityVC,animated: true)
        
    }
    
    
    
}
