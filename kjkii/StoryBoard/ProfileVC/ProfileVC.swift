//
//  ProfileVC.swift
//  kjkii
//
//  Created by Shahbaz on 28/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseDynamicLinks

class ProfileVC: UIViewController {
    
    var fbUser = ""
    var instaUser = ""
    var tiktokUser = ""
    var item1 : MeetUsers?
    var idToShare = 0
    @IBOutlet weak var tiktokImgVu: UIImageView!
    @IBOutlet weak var instaImgVu: UIImageView!
    @IBOutlet weak var fbImgVu: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var cannabisLbl: APLabel!
    @IBOutlet weak var userImage        : UIImageView!
    @IBOutlet weak var userName         : APLabel!
    @IBOutlet weak var gender           : APLabel!
    @IBOutlet weak var pronounce        : APLabel!
    @IBOutlet weak var bioLabel         : APLabel!
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
    var isOtherProfile                  = false
    
    @IBOutlet weak var viewEditProfile  : UIView!
    var id = String()
    var user : MeetUsers?
    override func viewDidLoad() {
        super.viewDidLoad()
        UIHelper.shared.popView(sender: self)
        UIHelper.shared.addBanners(container: self.containerView, sender: self)
//        let url = URL(string: "https://kikii.jobesk.com/public/storage/media/profile_pics/profile_pic.png")
//         userImage.sd_setImage(with: url, placeholderImage: UIImage(named: "file"), options:.highPriority, completed: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isOtherProfile{
            viewEditProfile.isHidden = true
        }else{
            viewEditProfile.isHidden = false
        }
        getProfile()
    }
    func getProfile(){
        let userID = GetProfile(id: id)
        userID.getProfile {[weak self] (result) in
            guard let self = self else {return}
            switch result{
            case .success(let data):
                if data.success ?? false {
                    self.setValues(item: data.user!)
                    self.idToShare = (data.user?.id)!
                    
                    
                }
                else{
                    self.alert(message: data.message ?? API_ERROR)
                }
            case .failure(let error):
                self.alert(message: error.rawValue)
            }
        }
    }
    func setValues(item: MeetUsers){
        self.user = item
       
        userName.text               = (item.name ?? "")
        UIHelper.shared.setImage(address: item.profile_pic ?? "", imgView: userImage)

        gender.text                 = item.gender_identity
        pronounce.text              = item.pronouns
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
        bioLabel.text               = item.bio
        cannabisLbl.text = item.cannabis
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
    @IBAction func viewFriendsBtnPressed(_ sender: Any) {
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let vc = stb.instantiateViewController(withIdentifier: "FriendsController") as! FriendsController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btntiktokPressed(_ sender: Any) {
        if tiktokUser != ""{
            let url1 = "https://www.tiktok.com/" + tiktokUser + "/"
            let url = URL(string: url1)
            UIApplication.shared.open(url!)
        }else{
            alert(message: "No profile found")
        }
    }
    @IBAction func btninstaPressed(_ sender: Any) {
        if instaUser != ""{
            let url1 = "https://www.instagram.com/" + instaUser + "/"
            let url = URL(string: url1)
            UIApplication.shared.open(url!)
        }else{
            alert(message: "No profile found")
        }
    }
    @IBAction func btnfacebookPressed(_ sender: Any) {
        if fbUser != ""{
            let url1 = "https://www.facebook.com/" + fbUser + "/"
            let url = URL(string: url1)
            UIApplication.shared.open(url!)
//            if let url = URL(string: "https://www.hackingwithswift.com") {
//                UIApplication.shared.open(url)
//            }
            
//            if UIApplication.shared.canOpenURL(url!) {
//                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//            }
//
            
        }else{
            alert(message: "No profile found")
        }
       
    }
    @IBAction func editBtnPressed(_ sender: Any)
    {
        let vc = EditProfileVC(nibName: "EditProfileVC", bundle: nil)
        vc.user = user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func shareBtnTpd(_ sender: Any) {
        
        let postIDValue = String(idToShare)
        var urlToShare: URL?
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.google.com"
        components.path = "/store"
        let postIDItems = URLQueryItem(name: "profile_id", value: postIDValue)
        components.queryItems = [postIDItems]
        guard let linkParameter = components.url else{return}
        print("I am sharing \(linkParameter.absoluteString)")
        let link = URL(string: "https://www.example.com/posts?profile_id=\(idToShare)")
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
    
    
    
    
}
