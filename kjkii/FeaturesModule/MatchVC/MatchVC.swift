//
//  MatchVC.swift
//  kjkii
//
//  Created by Shahbaz on 01/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import Koloda
import FirebaseAuth
import CoreLocation

class MatchVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var reportView     : UIView!
    @IBOutlet weak var containerview  : UIView!
    @IBOutlet weak var swipeView      : KolodaView!
    @IBOutlet weak var hidenView      : UIView!
    var isOpen                        = false
    var meetUsers                     = [MeetUsers]()
    var manager                       = CLLocationManager()
    var lat                           = Double()
    var lng                           = Double()
    var alreadyUserLiked = false
    var alreadyUserDisliked = false
    override func viewDidLoad() {
        super.viewDidLoad()
        UIHelper.shared.addBanners(container: containerview, sender: self)
        swipeView.dataSource    = self
        swipeView.delegate      = self
        observers()
        hidenView.alpha         = 0.0
        Common.shared.setUserAtFB()
        //print(CurrentUser.userData()!.auth_token ?? "")
        NotificationCenter.default.addObserver(self, selector: #selector(Call), name: NSNotification.Name(rawValue: "CALL"), object: nil)
        
        
    }
    func getSingleEvent(){
        let url = BASE_URL + "event" + "?id=" + "1"
       let finalURL = URL(string:url)!
       
        
        let logindata = [
                          
               "id": "1" ,
               
                   ] as [String : String]

        getSinglePostData(param: logindata, url: finalURL, onSuccess: { [self] (status, msg, res) in
              
//              let parseRes = ApiManager.responseParsingOrderHistory(result: res)
            
//            self.OrdersData = parseRes
            
            DispatchQueue.main.async {
                
            
            
            let jsonString = jsonToString(jsonTOConvert: res)
             let jsonData = jsonString.data(using: .utf8)
            
            let blogPosts: Json4Swift_Base = try! JSONDecoder().decode(Json4Swift_Base.self, from: jsonData!)
          print(blogPosts)
//            item = blogPosts
//
//
//            tblView.delegate    = self
//            tblView.dataSource  = self
            }
            
            
            
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
    
    @IBAction func btnreportPressed(_ sender: Any) {
        reportView.isHidden = true
    }
    @objc func Call(_ sender: NSNotification){
        
        let token = sender.userInfo?["Token"] as? String
        let channel = sender.userInfo?["Channel"] as? String
        let type = sender.userInfo?["Type"] as? String
        if type == "video"{
            let stb = UIStoryboard(name: "Main", bundle: nil)
            let vc = stb.instantiateViewController(withIdentifier: "VideoChatViewController") as! VideoChatViewController
            vc.token = token ?? ""
            vc.channel = channel ?? ""
            vc.isvideo = true
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let stb = UIStoryboard(name: "Main", bundle: nil)
            let vc = stb.instantiateViewController(withIdentifier: "VoiceChatViewController") as! VoiceChatViewController
            vc.token = token ?? ""
            vc.channel = channel ?? ""
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Common.shared.updateLocation(lat: "\(appDelegate.lat)", lng: "\(appDelegate.lng)") { [unowned self](done) in
            if done{
                print("Updated token......")
                print(appDelegate.firebaseToken)
                self.getMeet()
                self.updateToken()
                // if appDelegate.firebaseToken !=
            }
        }
    }
    
    func updateToken(){
        Common.shared.updateToken(token: appDelegate.firebaseToken,lastLogin: "") { (done) in
            if done{
                //print()
            }
        }
    }
    
    
    func observers(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.userLiked(_:)), name: NSNotification.Name(rawValue: "userLiked"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.disliked(_:)), name: NSNotification.Name(rawValue: "disliked"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.followUser(_:)), name: NSNotification.Name(rawValue: "followUser"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.blockUser(_:)), name: NSNotification.Name(rawValue: "userBlock"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reportUser(_:)), name: NSNotification.Name(rawValue: "userReport"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.share(_:)), name: NSNotification.Name(rawValue: "share"), object: nil)
        
    }
    
    
    func getMeet(){
        self.meetUsers.removeAll()
        self.swipeView.reloadData()
        print(CurrentUser.userData()!.auth_token!)
        showProgress(sender: self)
        GetMeets.shared.get { [unowned self] (result) in
            dismisProgress()
            switch result{
            case .success(let data):
                if data.success ?? false{
                    dump(data)
                    guard let users = data.users else {
                        self.alert(message: "Please Try later")
                        return
                    }
                    self.meetUsers = users
                    self.swipeView.reloadData()
                    
                }
                else{
                    self.alert(message: data.message ?? API_ERROR)
                }
            case .failure(let error):
                self.alert(message: error.rawValue)
            }
        }
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        restartApplication ()
        
    }
    @IBAction func rewindBtnPressed(_ sender: Any) {
        closeMenu()
        if DEFAULTS.string(forKey: "isPaid") == "0" {
            let stb = UIStoryboard(name: "Main", bundle: nil)
            let vc = stb.instantiateViewController(withIdentifier: "SubscriptioVC") as! SubscriptioVC
            vc.hidesBottomBarWhenPushed     = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            Common.shared.rewindSwipe { (response) in
                self.getMeet()
            }
        }
        
        
        
    }
    @IBAction func profileBtnPressed(_ sender: Any)
    {
        
        closeMenu()
        let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnSupportPressed(_ sender: Any) {
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let vc = stb.instantiateViewController(withIdentifier: "SupportController") as! SupportController
        vc.hidesBottomBarWhenPushed     = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func menuBtnPressed(_ sender: Any) {
        if isOpen{
            closeMenu()
        }
        else{
            openMenu()
        }
        
    }
    func restartApplication () {
        do
        {
            try Auth.auth().signOut()
        }
        catch let error as NSError
        {
            print (error.localizedDescription)
        }
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let navCtrl = stb.instantiateViewController(withIdentifier: "root") as! UINavigationController
        
        guard
            let window = UIApplication.shared.keyWindow,
            let rootViewController = window.rootViewController
        else {
            return
        }
        navCtrl.view.frame = rootViewController.view.frame
        navCtrl.view.layoutIfNeeded()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = navCtrl
        })
        
    }
    func openMenu(){
        UIView.animate(withDuration: 0.5) {
            self.hidenView.alpha = 1.0
        }
        isOpen = !isOpen
    }
    
    func closeMenu(){
        UIView.animate(withDuration: 0.5) {
            self.hidenView.alpha = 0.0
        }
        isOpen = !isOpen
    }
    @IBAction func filterBtnPressed(_ sender: Any) {
//        if DEFAULTS.string(forKey: "isPaid") == "0" {
//            let stb = UIStoryboard(name: "Main", bundle: nil)
//            let vc = stb.instantiateViewController(withIdentifier: "SubscriptioVC") as! SubscriptioVC
//            vc.hidesBottomBarWhenPushed     = true
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }else{
            let vc = FilterVC(nibName: "FilterVC", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
    }
    
    
    
    
    
    
}


extension MatchVC: KolodaViewDelegate {
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        //UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
    }
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if direction == .right{
            if alreadyUserLiked == false{
            likeUser(index: index)
            }else{
                alreadyUserLiked = false
            }
        } else if direction == .left{
            if alreadyUserDisliked == false{
            dislikeUser(index: index)
            }else{
                alreadyUserDisliked = false
            }
        }
    }
}

extension MatchVC: KolodaViewDataSource {
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return meetUsers.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .fast
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let oneCardView =  Bundle.main.loadNibNamed("OneSwipeCard", owner: self, options: nil)![0] as? OneSwipeCard
        oneCardView?.confiCard(item: meetUsers[index], sender: self)
        return oneCardView ?? UIView()
    }
    
    func likeUser(index: Int){
        showProgress(sender: self)
        let user = LikeUser(id: meetUsers[index].id ?? 0)
        user.likeUser { [unowned self](result) in
            dismisProgress()
            switch result{
            case .success(let data):
                if data.success ?? false{
                    self.alert(message: data.message ?? API_ERROR)
                }
                else{
                    self.alert(message: data.message ?? API_ERROR)
                }
                
            case .failure(let error):
                self.alert(message: error.rawValue)
            }
        }
    }
    @objc func userLiked(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let data = dict["userData"] as? LikeUserResponse{
                self.alert(message: data.message ?? API_ERROR)
                alreadyUserLiked = true
                swipeView.swipe(.right)
                
            }
            else{
                self.alert(message: API_ERROR)
            }
        }
    }
    
    @objc func disliked(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let data = dict["disliked"] as? DisLikedUserResponse{
                self.alert(message: data.message)
                alreadyUserDisliked = true
                swipeView.swipe(.left)
            }
            else{
                self.alert(message: API_ERROR)
            }
        }
    }
    
    func dislikeUser(index: Int){
        showProgress(sender: self)
        let user = DisLikeUser(id: meetUsers[index].id ?? 0)
        user.likeUser { [unowned self](result) in
            dismisProgress()
            switch result{
            case .success(let data):
                if data.success {
                    self.alert(message: data.message)
                }
                else{
                    self.alert(message: data.message)
                }
                
            case .failure(let error):
                self.alert(message: error.rawValue)
            }
        }
    }
    
    @objc func followUser(_ notification: NSNotification) {
        if let dict         = notification.userInfo as NSDictionary? {
            if let data     = dict["followUser"] as? DisLikedUserResponse{
                self.alert(message: data.message)
                self.getMeet()
            }
            else{
                self.alert(message: API_ERROR)
            }
        }
    }
    @objc func blockUser(_ notification: NSNotification) {
        let id = notification.userInfo?["id"] as? String
        let url = EndPoints.BASE_URL + "block/user"
        let param = ["id":id!]
        postWebCall(url: url, params: param, webCallName: "") { (response, error) in
            print(response)
            if !error{
                self.getMeet()
                self.alert(message: "\(response["message"])")
                
            }else{
                
            }
        }
        
    }
    @objc func share(_ notification: NSNotification){
        
        
    }
    @objc func reportUser(_ notification: NSNotification) {
        let id = notification.userInfo?["id"] as? String
        let url = EndPoints.BASE_URL + "save/report"
        let param = ["user_id":CurrentUser.userData()!.id!]
        postWebCall(url: url, params: param, webCallName: "") { (response, error) in
            print(response)
            if !error{
                self.reportView.isHidden = false
                //self.alert(message: "\(response["message"])")
                
            }else{
                
            }
        }
        
    }
    
    func updateLocation(){
        if CLLocationManager.locationServicesEnabled()
        {
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            manager                     = CLLocationManager()
            manager.delegate            = self
            manager.distanceFilter      = 500
            manager.desiredAccuracy     = kCLLocationAccuracyBest
            manager.startMonitoringSignificantLocationChanges()
            if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
            {
                lat = manager.location?.coordinate.latitude ?? 0.0
                lng = manager.location?.coordinate.longitude ?? 0.0
            }
            
            
        }
        else
        {
            manager.startUpdatingLocation()
            print("Location DIsables...")
        }
    }
}

