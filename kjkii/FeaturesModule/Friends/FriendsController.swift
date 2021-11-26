//
//  FriendsController.swift
//  kjkii
//
//  Created by abbas on 8/29/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import Alamofire


class FriendsController: UIViewController {
    
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var tabViewheight: NSLayoutConstraint!
    @IBOutlet weak var btnMyFriends: APButton!
    @IBOutlet weak var btnPendings: APButton!
    @IBOutlet weak var btnReqSent: APButton!
    @IBOutlet weak var tableVeiw: UITableView!
    var postType    : PostTypes = .myPosts
    var tabSelected = 0
    var myFrinds    = [CommunityUser]()
    var user_id     = String()
    var sentRequest : SentRequestsMain?
    var pendingRequest : PendingRequestsMain?
    var myFriends : MyFriendsMain?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabButtons()
        tableVeiw.delegate          = self
        tableVeiw.dataSource        = self
        tableVeiw.separatorStyle    = .none
        tableVeiw.allowsSelection   = false
        tableVeiw.backgroundColor   = .clear
        tableVeiw.rowHeight         = 100
        tableVeiw.register(UINib(nibName: "FriendCell", bundle: .main), forCellReuseIdentifier: "FriendCell")
        self.getSentRequest()
        if postType == .otherPosts{
            tabView.isHidden = true
            tabViewheight.constant = 0.0
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension FriendsController {
    @IBAction func btnTabPressed(_ sender: UIButton) {
        self.tabSelected = sender.tag
        switch sender.tag {
             case 0:
                self.btnMyFriends.customize(font: .font24, .bold, .redText, for: .normal)
                self.btnPendings.customize(font: .font20, .bold, .grayText, for: .normal)
                self.btnReqSent.customize(font: .font20, .bold, .grayText, for: .normal)
//                self.getMyFrineds()
                self.getSentRequest()
             case 1:
                self.btnMyFriends.customize(font: .font20, .bold, .grayText, for: .normal)
                self.btnPendings.customize(font: .font24, .bold, .redText, for: .normal)
                self.btnReqSent.customize(font: .font20, .bold, .grayText, for: .normal)
//                self.getResquests()
                self.getSentRequest()
             default:
                self.btnMyFriends.customize(font: .font20, .bold, .grayText, for: .normal)
                self.btnPendings.customize(font: .font20, .bold, .grayText, for: .normal)
                self.btnReqSent.customize(font: .font24, .bold, .redText, for: .normal)
                self.getSentRequest()
        }
    }
    
    func configureTabButtons(){
        btnMyFriends.customize(font: .font24, .bold, .redText, for: .normal)
        btnPendings.customize(font: .font20, .bold, .grayText, for: .normal)
        btnReqSent.customize(font: .font20, .bold, .grayText, for: .normal)
    }
    func getMyFrineds(){
        
        var url = String()
        
        if postType == .otherPosts{
            url = EndPoints.BASE_URL + "user/friends?user_id=\(user_id)"
        }
        else{
            url = EndPoints.BASE_URL + "my/friends"
        }
        
        showProgress(sender: self)
        MyFriends.shared.getMyFriends(url: url) { [weak self] (result) in
            guard let self = self else {return}
            dismisProgress()
            switch result{
            case .success(let data):
                    if let users = data.users {
                        if users.count > 0{
                            self.myFrinds = users
                        }
                        else{
                            self.alert(message: "Friends not found yet")
                        }
                    }
                    self.tableVeiw.reloadData()
            case .failure(let error):
                self.alert(message: error.rawValue)
            }
            
        }
    }
    func getResquests(){
        showProgress(sender: self)
        MyFriends.shared.getMyRequests { [unowned self] (result) in
            dismisProgress()
            switch result{
            case .success(let data):
                if let users = data.users {
                    if users.count > 0{
                        self.myFrinds = users
                    }
                    else{
                        self.alert(message: "Friends not found yet")
                    }
                }
                self.tableVeiw.reloadData()
                
            case .failure(let error):
                self.alert(message: error.rawValue)
            }
            
        }
    }
    func getSentRequest(){
        showProgress(sender: self)
//        MyFriends.shared.getSentRequests { [unowned self] (result) in
//            dismisProgress()
//            switch result{
//            case .success(let data):
//                if let users = data.users {
//                    if users.count > 0{
//                        self.myFrinds = users
//                    }
//                    else{
//                        self.alert(message: "Friends not found yet")
//                    }
//                }
//                self.tableVeiw.reloadData()
//
//            case .failure(let error):
//                self.alert(message: error.rawValue)
//            }
//
//        }
        
        getSentRequestNew(onSuccess: { (status, msg, res) in
            dismisProgress()
            let datato = res.value(forKey: "Sent requests")
            let jsonString = self.jsonToString(jsonTOConvert: res)
             let jsonData = jsonString.data(using: .utf8)
            if self.tabSelected == 0{
            let blogPosts: MyFriendsMain = try! JSONDecoder().decode(MyFriendsMain.self, from: jsonData!)
            self.myFriends = blogPosts
            }else if self.tabSelected == 1{
                let blogPosts: PendingRequestsMain = try! JSONDecoder().decode(PendingRequestsMain.self, from: jsonData!)
                self.pendingRequest = blogPosts
                if self.pendingRequest?.pendingrequests?.count ?? 0 == 0{
               self.alert(message: "Friends not found yet")
                }
                
                
            }else if self.tabSelected == 2{
                let blogPosts: SentRequestsMain = try! JSONDecoder().decode(SentRequestsMain.self, from: jsonData!)
                self.sentRequest = blogPosts
                if self.sentRequest?.sentrequests?.count ?? 0 == 0{
               self.alert(message: "Friends not found yet")
                }
            }
            self.tableVeiw.reloadData()
           
           
    
         }) { (status, msg, res) in
             
            dismisProgress()
                 print("DO NOT RESET PRESCRIPTION COMMAND FROM PRESCRIPTION VC")
                 
             
             print(res)
         }
        
        
    }
    func getSentRequestNew(onSuccess : @escaping (Bool, String, AnyObject) -> Void, onFailure : @escaping (Bool, String, AnyObject) -> Void) {
        
       var url =  ""
        if tabSelected == 0{
          url = EndPoints.BASE_URL + "my/friends"
            
        }else if tabSelected == 1{
            url = EndPoints.BASE_URL + "pending/requests"
            
        }else if tabSelected == 2{
            url =  EndPoints.BASE_URL + "sent/requests"
        }
       
        Alamofire.request(url, method: .get,encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
               
    //            print(response.result.value)
                    switch response.result {
                    case .success:
                       onSuccess(true, response.result.description, response.result.value as AnyObject)
    //                    print(response.result.value)
                    case .failure(let error):
                        print(error)
                        onFailure(false, response.error?.localizedDescription ?? "Something went wrong.", response.error as AnyObject)
                    }
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

extension FriendsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        switch tabSelected {
        case 0:
            return myFriends?.friends?.count ?? 0
        case 1:
            return pendingRequest?.pendingrequests?.count ?? 0
        case 2:
            return sentRequest?.sentrequests?.count ?? 0
        default:
            return sentRequest?.sentrequests?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell") as! FriendCell
        if tabSelected == 0{
            cell.setDataFriends(type: .iconfriend, item: (myFriends?.friends?[indexPath.row])!)
        } else if tabSelected == 1{
            cell.setDataPending(type: .iconpending, item: (pendingRequest?.pendingrequests?[indexPath.row])!)
        }else if tabSelected == 2{
            cell.setData(type: .iconreqsent, item: (sentRequest?.sentrequests?[indexPath.row])!)
        }
        cell.sideBtn.tag = indexPath.row
        cell.sideBtn.addTarget(self, action: #selector(sideBtnPressed(_:)), for: .touchUpInside)
        cell.mainBtn.tag = indexPath.row
        cell.mainBtn.addTarget(self, action: #selector(mainBtnPressed(_:)), for: .touchUpInside)
        return cell
    }
    
    
    
    @objc func sideBtnPressed(_ sender: UIButton){
//        let id = myFrinds[sender.tag].id!
      
        if tabSelected == 1{
            let id = pendingRequest?.pendingrequests?[sender.tag].id
            likeUser(id: id!)
        } else if tabSelected == 2{
            let id = sentRequest?.sentrequests?[sender.tag].id
            unfollowUser(id: id!)
        }
    }
    func likeUser(id: Int){
        showProgress(sender: self)
        let user = FollowUser(id: id)
        user.likeUser { [unowned self](result) in
            dismisProgress()
            switch result{
            case .success(let data):
                if data.success {
                    self.myAlert(message: data.message )
                }
                else{
                    self.alert(message: data.message )
                }
                
            case .failure(let error):
                self.alert(message: error.rawValue)
            }
        }
    }
    func unfollowUser(id: Int){
        showProgress(sender: self)
        let user = LikeUser(id: id)
        user.unfollow { [unowned self](result) in
            dismisProgress()
            switch result{
            case .success(let data):
                if data.success ?? false{
                    self.myAlert(message: data.message ?? API_ERROR)
                }
                else{
                    self.alert(message: data.message ?? API_ERROR)
                }
            case .failure(let error):
                self.alert(message: error.rawValue)
            }
        }
    }
    func myAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
//            self.tabSelected = 0
//            self.btnMyFriends.customize(font: .font24, .bold, .redText, for: .normal)
//            self.btnPendings.customize(font: .font20, .bold, .grayText, for: .normal)
//            self.btnReqSent.customize(font: .font20, .bold, .grayText, for: .normal)
//            self.getMyFrineds()
            self.getSentRequest()
        })
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func mainBtnPressed(_ sener: UIButton){
        let id = myFrinds[sener.tag].id ?? 0
        if id == CurrentUser.userData()?.id{
            let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
            vc.id  = "\(id)"
            vc.isOtherProfile = false
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
            vc.id  = "\(id)"
            vc.isOtherProfile = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}



