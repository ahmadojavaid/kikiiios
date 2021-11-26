//
//  OneSwipeCard.swift
//  kjkii
//
//  Created by Shahbaz on 14/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import Nuke
import ProgressHUD
import FirebaseDynamicLinks
import Alamofire
protocol shareProfileDelegate {
   func didTapShare(link:URL)
}
class OneSwipeCard: UIView {
    var fbUser = ""
    var instaUser = ""
    var tiktokUser = ""
    var shareDelegate: shareProfileDelegate!
    
    @IBOutlet weak var fbImgVu: UIImageView!
    
    @IBOutlet weak var instaImgVu: UIImageView!
    
    @IBOutlet weak var tiktokImgVu: UIImageView!
    
    @IBOutlet weak var reportHeight     : NSLayoutConstraint!
    @IBOutlet weak var reportView       : UIView!
    @IBOutlet weak var frinedLbl        : APLabel!
    @IBOutlet weak var friendView       : UIView!
    @IBOutlet weak var friendHeight     : NSLayoutConstraint!
    @IBOutlet weak var postsView        : UIView!
    @IBOutlet weak var postHeight       : NSLayoutConstraint!
    @IBOutlet weak var whoIamLabel      : UIView!
    @IBOutlet weak var curiosHeight     : NSLayoutConstraint!
    @IBOutlet weak var cusView          : UIView!
    @IBOutlet weak var scrolView        : UIScrollView!
    @IBOutlet weak var smallPronouce    : APLabel!
    @IBOutlet weak var smallGender      : APLabel!
    @IBOutlet weak var smallDistanceLbl : APLabel!
    @IBOutlet weak var smallStateView   : UIView!
    @IBOutlet weak var userImage        : UIImageView!
    @IBOutlet weak var pronounce        : APLabel!
    @IBOutlet weak var userName         : APLabel!
    @IBOutlet weak var destanceLbl      : APLabel!
    @IBOutlet weak var genderLabel      : APLabel!
    @IBOutlet weak var whoIam           : APLabel!
    @IBOutlet weak var relationship_label: APLabel!
    @IBOutlet weak var heightLabel      : APLabel!
    @IBOutlet weak var lookingForLabel  : APLabel!
    @IBOutlet weak var smokeLabel       : APLabel!
    @IBOutlet weak var drinkLabel       : APLabel!
    @IBOutlet weak var politicalLbl     : APLabel!
    @IBOutlet weak var canbisLabel      : APLabel!
    @IBOutlet weak var religionLabel    : APLabel!
    @IBOutlet weak var starLbl          : APLabel!
    @IBOutlet weak var diteLabel        : APLabel!
    @IBOutlet weak var animalLabel      : APLabel!
    @IBOutlet weak var kidLbl           : APLabel!
    @IBOutlet weak var likedAccountView : UIView!
    @IBOutlet weak var linkedViewHeight : NSLayoutConstraint!
    @IBOutlet weak var downView         : UIView!
    @IBOutlet weak var upView           : UIView!
    var item                            : MeetUsers?
    var isOpen                          = false
    var contentSize                     = CGFloat()
    
    var sender                          = UIViewController()
    
    func confiCard(item: MeetUsers, sender : UIViewController){
        whoIamLabel.isHidden = true
        self.item                   = item
        let df                      = DateFormatter()
        df.dateFormat               = "yyyy-MM-dd"
        if let birthday = item.birthday {
            let selectedDate            = df.date(from: birthday)
            let years                   = UIHelper.shared.yearsBetweenDate(startDate: selectedDate ?? Date(), endDate: Date())
            userName.text               = (item.name ?? "") + " , " + "\(years)  "
        }
        else{
            userName.text               = (item.name ?? "")
        }
        
        UIHelper.shared.setImage(address: item.profile_pic ?? "", imgView: userImage)
        genderLabel.text            = item.gender_identity
        destanceLbl.text            = item.distance
        pronounce.text              = item.pronouns
        smallDistanceLbl.text       = item.distance
        smallGender.text            = item.gender_identity
        smallPronouce.text          = item.pronouns
        relationship_label.text     = item.relationship_status
        heightLabel.text            = item.height
        lookingForLabel.text        = item.looking_for
        smokeLabel.text             = item.smoke
        drinkLabel.text             = item.drink
        politicalLbl.text           = item.political_views
        canbisLabel.text            = item.cannabis
        religionLabel.text          = item.religion
        starLbl.text                = item.sign
        diteLabel.text              = item.diet_like
        animalLabel.text            = item.pets
        kidLbl.text                 = item.kids
        hidenState()
        if let insta = item.instagram{
        instaUser = insta
            instaImgVu.image = UIImage(named: "insta")
        }
        if let fb = item.facebook{
            fbUser = fb
            fbImgVu.image = UIImage(named: "fbfilled")
        }
        if let tiktok = item.tiktok{
            tiktokUser = tiktok
            tiktokImgVu.image = UIImage(named: "tiktokfilled")
        }
    }
    
    @IBAction func viewPostsBtnPressed(_ sender: Any)
    {
        let data = ["user_id":"\(item!.id ?? 0)"]
        NotificationCenter.default.post(name: NSNotification.Name("onePost"), object: nil, userInfo: data)
    }
    @IBAction func viewFriendsBtnPressed(_ sender: Any)
    {
        let data = ["user_id":"\(item!.id ?? 0)"]
        NotificationCenter.default.post(name: NSNotification.Name("oneFriend"), object: nil, userInfo: data)
    }
    
    
    @IBAction func downBtnPressed(_ sender: Any)
    {
        shownState()
    }
    @IBAction func hideBtnPressed(_ sender: Any) {
        hidenState()
    }
    
    
    func shownState(){
        reportView.isHidden         = false
        reportHeight.constant       = 130
        smallStateView.isHidden     = true
        whoIamLabel.isHidden        = false
        whoIam.text                 = item?.bio
        curiosHeight.constant       = 300
        cusView.isHidden            = false
        postHeight.constant         = 100.0
        postsView.isHidden          = false
        friendView.isHidden         = false
        friendHeight.constant       = 120.0
        likedAccountView.isHidden   = false
        linkedViewHeight.constant   = 100.0
        downView.isHidden           = true
        upView.isHidden             = false
    }
    
    
    
    func hidenState(){
        reportView.isHidden         = true
        reportHeight.constant       = 0.0
        smallStateView.isHidden     = false
        whoIamLabel.isHidden        = true
        whoIam.text                 = ""
        curiosHeight.constant       = 0
        cusView.isHidden            = true
        postHeight.constant         = 0.0
        postsView.isHidden          = true
        frinedLbl.text              = "(\(item!.friends_count ?? 0) friends)"
        friendView.isHidden         = true
        friendHeight.constant       = 0.0
        likedAccountView.isHidden   = true
        linkedViewHeight.constant   = 0.0
        downView.isHidden           = false
        upView.isHidden             = true
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        
        
        
        
//        guard let link = URL(string: "https://www.example.com/my-page") else { return }
//        let dynamicLinksDomainURIPrefix = "https://example.com/link"
//        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
//
//        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.example.ios")
//        linkBuilder?.iOSParameters?.appStoreID = "123456789"
//        linkBuilder?.iOSParameters?.minimumAppVersion = "1.2.3"
//
//        linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: "com.example.android")
//        linkBuilder?.androidParameters?.minimumVersion = 123
//
//        linkBuilder?.analyticsParameters = DynamicLinkGoogleAnalyticsParameters(source: "orkut",
//                                                                                medium: "social",
//                                                                                campaign: "example-promo")
//
//        linkBuilder?.iTunesConnectParameters = DynamicLinkItunesConnectAnalyticsParameters()
//        linkBuilder?.iTunesConnectParameters?.providerToken = "123456"
//        linkBuilder?.iTunesConnectParameters?.campaignToken = "example-promo"
//
//        linkBuilder?.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
//        linkBuilder?.socialMetaTagParameters?.title = "Example of a Dynamic Link"
//        linkBuilder?.socialMetaTagParameters?.descriptionText = "This link works whether the app is installed or not!"
//        //        linkBuilder?.socialMetaTagParameters?.imageURL = "https://www.example.com/my-image.jpg"
//
//        guard let longDynamicLink = linkBuilder?.url else { return }
//        print("The long URL is: \(longDynamicLink)")
//        linkBuilder?.shorten() { url, warnings, error in
//                  guard let url = url, error != nil else { return }
//                  print("The short URL is: \(url)")
//                }
        //        guard let link = URL(string: "https://www.example.com/my-page") else { return }
        //        let dynamicLinksDomainURIPrefix = "https://example.com/link"
        //        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: dynamicLinksDomainURIPrefix)
        //        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.example.ios")
        //        linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: "com.example.android")
        //
        //        guard let longDynamicLink = linkBuilder?.url else { return }
        //        print("The long URL is: \(longDynamicLink)")
        //
        //        linkBuilder?.shorten() { url, warnings, error in
        //          guard let url = url, error != nil else { return }
        //          print("The short URL is: \(url)")
        //        }
        //
        //        linkBuilder?.options = DynamicLinkComponentsOptions()
        //        linkBuilder?.options.pathLength = .short
        //        linkBuilder?.shorten() { url, warnings, error in
        //          guard let url = url, error != nil else { return }
        //          print("The short URL is: \(url)")
        //        }
        //
        
        
//        ciommenting this too
        
       
        let postIDValue = String((item?.id)!)
        var urlToShare: URL?
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.google.com"
        components.path = "/store"
        let postIDItems = URLQueryItem(name: "profile_id", value: postIDValue)
        components.queryItems = [postIDItems]
        guard let linkParameter = components.url else{return}
        print("I am sharing \(linkParameter.absoluteString)")
        let link = URL(string: "https://www.example.com/posts?profile_id=\(item?.id)")
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
//        present(activityVC,animated: true)
        
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil) {
             topVC = topVC!.presentedViewController
        }
        topVC?.present(activityVC,animated: true)
        
    }
    @IBAction func reportBtnPressed(_ sender: Any) {
        reportUser()
    }
    @IBAction func blockBtnPressed(_ sender: Any) {
        BlockUser()
    }
    @IBAction func likeBtnPressed(_ sender: Any)
    {
        print("I am clicked... ")
        likeUser()
    }
    func BlockUser(){
        let data : [String:String] = ["id": "\(item!.id!)"]
        NotificationCenter.default.post(name: NSNotification.Name("userBlock"), object: nil, userInfo: data)
        
    }
    func reportUser(){
        let data : [String:String] = ["id": "\(item!.id!)"]
        NotificationCenter.default.post(name: NSNotification.Name("userReport"), object: nil, userInfo: data)
    }
    func likeUser(){
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorHUD = UIColor(named: "appRed")!
        ProgressHUD.show()
        let user = LikeUser(id: item!.id ?? 0)
        user.likeUser {(result) in
            ProgressHUD.dismiss()
            switch result{
            case .success(let data):
                let data = ["userData":data]
                NotificationCenter.default.post(name: NSNotification.Name("userLiked"), object: nil, userInfo: data)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    @IBAction func dislikeBtnPressed(_ sender: Any)
    {
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorHUD = UIColor(named: "appRed")!
        ProgressHUD.show()
        let user = DisLikeUser(id: item!.id ?? 0)
        user.likeUser {(result) in
            ProgressHUD.dismiss()
            switch result{
            case .success(let data):
                let data = ["disliked":data]
                NotificationCenter.default.post(name: NSNotification.Name("disliked"), object: nil, userInfo: data)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    @IBAction func followBtnPressed(_ sender: Any) {
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorHUD = UIColor(named: "appRed")!
        ProgressHUD.show()
        let user = FollowUser(id: item!.id ?? 0)
        user.likeUser {(result) in
            ProgressHUD.dismiss()
            switch result{
            case .success(let data):
                let data = ["followUser":data]
                NotificationCenter.default.post(name: NSNotification.Name("followUser"), object: nil, userInfo: data)
            case .failure(let error):
                print(error.rawValue)
            }
        }

        
    }
   
    
    
    @IBAction func fbBtnTpd(_ sender: Any) {
        if fbUser != ""{
            let url1 = "https://www.facebook.com/" + fbUser + "/"
            let url = URL(string: url1)
            UIApplication.shared.open(url!)
        }else{
//            alert(message: "No profile found")
                   print("nothing found")
        }
    }
    
    @IBAction func instaBtnTpd(_ sender: Any) {
        if instaUser != ""{
            let url1 = "https://www.instagram.com/" + instaUser + "/"
            let url = URL(string: url1)
            UIApplication.shared.open(url!)
        }else{
//            alert(message: "No profile found")
            print("nothing found")
        }
    }
   
    
    
    @IBAction func tiktokBtnTpd(_ sender: Any) {
        if tiktokUser != ""{
            let url1 = "https://www.tiktok.com/" + tiktokUser + "/"
            let url = URL(string: url1)
            UIApplication.shared.open(url!)
        }else{
//            alert(message: "No profile found")
                   print("nothing found")
        }
    }
}
//func addFollow(param: [String: Any],onSuccess : @escaping (Bool, String, AnyObject) -> Void, onFailure : @escaping (Bool, String, AnyObject) -> Void) {
//    let url = EndPoints.BASE_URL + "follow/user"
//    Alamofire.request(url, method: .post,parameters:param , encoding: URLEncoding.default).responseJSON { (response) in
//
////            print(response.result.value)
//                switch response.result {
//                case .success:
//                   onSuccess(true, response.result.description, response.result.value as AnyObject)
//                    print(response.result.value)
//                case .failure(let error):
//                    print(error)
//                    onFailure(false, response.error?.localizedDescription ?? "Something went wrong.", response.error as AnyObject)
//                }
//            }
//
//        }
