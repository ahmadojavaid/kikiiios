//
//  CommunityVC.swift
//  kjkii
//
//  Created by Shahbaz on 06/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import Lightbox
import FirebaseDynamicLinks

class CommunityVC: UIViewController {
    
    @IBOutlet weak var createPostImgVu: UIImageView!
    @IBOutlet weak var createPostBtn: UIButton!
    @IBOutlet weak var containerview        : UIView!
    @IBOutlet weak var addView              : UIView!
    @IBOutlet weak var tabView              : UIView!
    @IBOutlet weak var backBtnViewWidth     : NSLayoutConstraint!
    @IBOutlet weak var tabheight            : NSLayoutConstraint!
    @IBOutlet weak var backBTnView          : UIView!
    @IBOutlet var viewsToHide               : [UIView]!
    @IBOutlet weak var tblView              : UITableView!
    @IBOutlet var lbls                      : [APLabel]!
    var type : VCType                       = .community
    var communityPosts                      = [Posts]()
    var events                              = [Event]()
    var kikiPosts                           = [KiPosts]()
    var communityIndex                      = Int()
    var user_id                             : String?
    var postTypes                           : PostTypes = .myPosts
    var isLast                              = false
    var offset                              = "0"
    var createPostBtnTag = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(UINib(nibName: "CommunityCell", bundle: nil), forCellReuseIdentifier: "CommunityCell")
        tblView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCell")
        tblView.register(UINib(nibName: "KikiiCell", bundle: nil), forCellReuseIdentifier: "KikiiCell")
        tblView.register(UINib(nibName: "AdsCell", bundle: nil), forCellReuseIdentifier: "AdsCell")
        tblView.delegate = self
        tblView.dataSource = self
        UIHelper.shared.addBanners(container: containerview, sender: self)
        
    }
    
    @IBAction func bcakBTnPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if postTypes == .otherPosts
        {
            addView.isHidden        = true
            backBTnView.isHidden    = false
            backBtnViewWidth.constant = 50
            tabView.isHidden        = true
            tabheight.constant      = 0.0
        }
        else{
            addView.isHidden        = false
            backBTnView.isHidden    = true
            backBtnViewWidth.constant = 0
            tabView.isHidden        = false
            tabheight.constant      = 50.0
        }
        
        communityPosts.removeAll()
        getPosts()
    }
    func getPosts(){
        switch type {
        case .community:
            getCommuniPosts(offset: "0")
        case .events:
            getEvents()
        case .kikii:
            getKikiPosts()
        }
    }
    
    @IBAction func optionBtns(_ sender: Any) {
        lbls.forEach({$0.textColor = Theme.Colors.grayText})
        let tag = (sender as AnyObject).tag!
        if tag == 0{
            type = .community
            createPostBtn.isHidden = false
            createPostImgVu.isHidden = false
            createPostImgVu.image = UIImage(named: "plusicon")
            createPostBtnTag = 0
            getCommuniPosts(offset: "0")
        } else if tag == 1{
            type = .events
            createPostBtn.isHidden = true
            createPostImgVu.isHidden = true
            getEvents()
        } else if tag == 2{
            type = .kikii
            createPostImgVu.isHidden = false
            createPostBtn.isHidden = false
            createPostImgVu.image = UIImage(named: "infoicon")
            createPostBtnTag = 2
            getKikiPosts()
        }
        lbls[tag].textColor = Theme.Colors.redText
        tblView.reloadData()
    }
    @IBAction func createPostBtn(_ sender: Any) {
        if createPostBtnTag == 0{
        let vc = CreatePostVC(nibName: "CreatePostVC", bundle: nil)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
            
//            navigationController?.pushViewController(viewControllerB, animated: true)
         
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getCommuniPosts(offset:String){
        
        var url : URL?
        if postTypes == .myPosts{
            url = URL(string: EndPoints.BASE_URL + "community?offset=" + offset)!
        }
        else{
            url = URL(string: EndPoints.BASE_URL + "user/posts?offset=0&user_id=\(user_id ?? "")")
        }
        showProgress(sender: self)
        let offset = ComPosts(offset: "0", user_id: user_id ?? "\(CurrentUser.userData()!.id ?? 0)", url: url)
        offset.getPosts { [unowned self](result) in
            dismisProgress()
            switch result{
            case .success(let data):
                if data.success ?? false{
                    dismisProgress()
                    if let posts = data.posts{
                        
                        if posts.count == 0 {
                            self.isLast = true
                        }
                        self.communityPosts.append(contentsOf: posts)
                       
                        DispatchQueue.main.async {
                            
                        
                        self.tblView.reloadData()
                        }
                    }
                  
                    
                    
                    
                }
                else{
                    dismisProgress()
                    self.alert(message: data.message ?? API_ERROR)
                }
                self.offset = "\(data.next_offset ?? 0)"
                print("pagination")
                print(self.offset)
            case .failure(let error):
                dismisProgress()
                self.alert(message: error.rawValue)
            }
            
        }
    }
    
    func getEvents(){
        print("eventss")
        showProgress(sender: self)
        GetEvents.shared.getEvents { [unowned self](result) in
            dismisProgress()
            switch result{
            case .success(let data):
                print("eventsss")
                dump(data.events)
                self.events = data.events
                self.tblView.reloadData()
                
            case .failure(let error):
                self.alert(message: error.rawValue)
            }
        }
    }
    
    func getKikiPosts(){
        showProgress(sender: self)
        GetKikiPosts.shared.getPosts { [unowned self](result) in
            dismisProgress()
            switch result{
            case .success(let data):
                if data.success ?? false{
                    if let posts = data.posts{
                        self.kikiPosts = posts
                    }
                    else{
                        self.alert(message: API_ERROR)
                    }
                    self.tblView.reloadData()
                }
                else{
                    self.alert(message: data.message ?? API_ERROR)
                }
            case .failure(let error):
                self.alert(message: error.rawValue)
            }
        }
        
    }
    
    
    
    
}






extension CommunityVC : UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if type == .community{
            return communityPosts.count
        }
        else if type == .events{
            return events.count
        }
        else{
            return kikiPosts.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if type == .community{
            
            if let path = communityPosts[indexPath.row].path{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AdsCell") as! AdsCell
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                UIHelper.shared.setImage(address: path ?? "", imgView: cell.add_image)
                return cell
                
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityCell") as! CommunityCell
                cell.config(item: communityPosts[indexPath.row])
                cell.selectionStyle = .none
                if communityPosts[indexPath.row].user != nil{
                 let userImgURL = communityPosts[indexPath.row].user.profile_pic
                    if userImgURL != nil{
                    let imgURL = URL(string: userImgURL!)
                cell.userImage.sd_setImage(with: imgURL, placeholderImage: UIImage(named: "shareicon"), options:.highPriority, completed: nil)
                
                }
                }
//                UIHelper.shared.setImage(address: userImgURL ?? "", imgView: cell.userImage)
                cell.showAllImages.tag = indexPath.row
                cell.showAllImages.addTarget(self, action: #selector(showImages(_:)), for: .touchUpInside)
                cell.commentBtn.tag = indexPath.row
                cell.commentBtn.addTarget(self, action: #selector(commentBtnPressed(_:)), for: .touchUpInside)
                cell.likeBtn.tag = indexPath.row
                cell.likeBtn.addTarget(self, action: #selector(likePost(_:)), for: .touchUpInside)
                cell.moreBtn.tag = indexPath.row
                cell.moreBtn.addTarget(self, action: #selector(communityMorePressed(_:)), for: .touchUpInside)
                cell.shareBtn.tag = indexPath.row
                cell.shareBtn.addTarget(self, action: #selector(shareBtnPressed(_:)), for: .touchUpInside)
                return cell
            }
          
        } else if type == .events{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
            cell.configCell(item: events[indexPath.row])
            cell.addBtn.tag = indexPath.row
            cell.addBtn.addTarget(self, action: #selector(attendEvent(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "KikiiCell") as! KikiiCell
            cell.configCell(item: kikiPosts[indexPath.row])
            cell.commentBtn.tag  = indexPath.row
            cell.commentBtn.addTarget(self, action: #selector(kikiCommentBtnPressed(_:)), for: .touchUpInside)
            cell.likeBtn.tag = indexPath.row
            cell.likeBtn.addTarget(self, action: #selector(likeKikiPost(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == .events{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailVC") as! EventDetailVC
            vc.item = events[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        } else if type == .community{
            if let link = communityPosts[indexPath.row].link{
                guard let url = URL(string: link ?? "") else {
                    return
                }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if type == .community{
            
            if indexPath.row ==  communityPosts.count - 1{
                if !isLast{
                    self.getCommuniPosts(offset: offset)
                }
            }
        }
        
    }
    
    
    @objc func attendEvent(_ sender: UIButton){
        Common.shared.attendEvent(id: "\(events[sender.tag].id)") { [unowned self](response, error) in
            if !error{
                let message = "\(response["message"])"
                self.alert(message: message)
            }
        }
    }
    
    @objc func shareBtnPressed(_ sender: UIButton){
        let tag = sender.tag
let postIDValue = String(communityPosts[tag].id!)
        var urlToShare: URL?
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.google.com"
        components.path = "/store"
        let postIDItems = URLQueryItem(name: "post_id", value: postIDValue)
        components.queryItems = [postIDItems]
        guard let linkParameter = components.url else{return}
        print("I am sharing \(linkParameter.absoluteString)")
        let link = URL(string: "https://www.example.com/posts?post_id=\(communityPosts[tag].id!)")
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
    
    
    
    
    @objc func showImages(_ sender: UIButton){
        let tag = sender.tag
        let media = communityPosts[tag].media
        var imgs = [LightboxImage]()
        for img in media!{
            imgs.append(LightboxImage(imageURL: URL(string: img.path ?? "")!))
        }
        let controller = LightboxController(images: imgs)
        controller.dynamicBackground = true
        present(controller, animated: true, completion: nil)
        
    }
    @objc func commentBtnPressed(_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommunityDetailVC") as! CommunityDetailVC
        vc.post = communityPosts[sender.tag]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func likePost(_ sender: UIButton){
        showProgress(sender: self)
        let postID = LikePost(post_id: "\(communityPosts[sender.tag].id ?? 0)")
        postID.likePost { [unowned self](done, data) in
            dismisProgress()
            if done{
                
                let cell = tblView.cellForRow(at: IndexPath(item: sender.tag, section: 0)) as! CommunityCell
                let count = Int(cell.likesCount.text!)!
                
                if let data = data{
                    if data.message.contains("Disliked"){
                        cell.likeImg.image = UIImage(systemName: "heart")
                        cell.likesCount.text = "\(count - 1)"
                    }
                    else{
                        cell.likeImg.image = UIImage(systemName: "heart.fill")
                        cell.likesCount.text = "\(count + 1)"
                    }
                }
            }
            else{
                self.alert(message: API_ERROR)
            }
        }
    }
    
    @objc func likeKikiPost(_ sender: UIButton){
        showProgress(sender: self)
        let postID = LikePost(post_id: "\(kikiPosts[sender.tag].id ?? 0)")
        postID.likePost { [unowned self](done, data) in
            dismisProgress()
            if done{
                self.getPosts()
                //                let cell = tblView.cellForRow(at: IndexPath(item: sender.tag, section: 0)) as! KikiiCell
                //                let count = Int(cell.likeCount.text!)!
                //                if let data = data{
                //                    if data.message.contains("Disliked"){
                //                        cell.likeImage.image = UIImage(systemName: "heart")
                //                        cell.likeCount.text = "\(count - 1)"
                //                    }
                //                    else{
                //                        cell.likeImage.image = UIImage(systemName: "heart.fill")
                //                        cell.likeCount.text = "\(count + 1)"
                //                    }
                //                }
            }
            else{
                self.alert(message: API_ERROR)
            }
        }
        
    }
    
    @objc func kikiCommentBtnPressed (_ sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommunityDetailVC") as! CommunityDetailVC
        vc.kiki     = true
        vc.kikiPost = kikiPosts[sender.tag]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func communityMorePressed(_ sender: UIButton){
        if "\(communityPosts[sender.tag].user_id ?? 0)" == "\(CurrentUser.userData()!.id!)"{
            self.communityIndex = communityPosts[sender.tag].id ?? 0
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Delete", style: .default, handler: {
                action in
                self.deletePost()
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Update", style: .default, handler: {
                action in
                let vc = CreatePostVC(nibName: "CreatePostVC", bundle: nil)
                vc.hidesBottomBarWhenPushed = true
                vc.isUpdate = true
                vc.communityPosts = self.communityPosts[sender.tag]
                self.navigationController?.pushViewController(vc, animated: true)
                
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
                action in
                
                
            }))
            actionSheet.popoverPresentationController?.sourceView = sender
            actionSheet.popoverPresentationController?.sourceRect = sender.frame
            present(actionSheet, animated: true, completion: nil)
        }
        else{
            self.communityIndex = communityPosts[sender.tag].id ?? 0
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Report", style: .default, handler: {
                action in
                self.reportPost(postid:"\(self.communityPosts[sender.tag].id!)")
                
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
                action in
                
                
            }))
            actionSheet.popoverPresentationController?.sourceView = sender
            actionSheet.popoverPresentationController?.sourceRect = sender.frame
            present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func ActionSheet(mypost:Bool){
        if mypost{
            
        }else{
            
        }
        
    }
    
    func deletePost(){
        let url = EndPoints.BASE_URL + "delete/post/\(communityIndex)"
        let params = ["":""]
        deleteWebCall(url: url, params: params, webCallName: "Delteing post", sender: self) { [unowned self](response, error) in
            if !error{
//              self.getCommuniPosts(offset: offset)
                self.communityPosts.removeAll()
                self.getCommuniPosts(offset: "0")
               
                }
            
        }
        
    }
    
    func reportPost(postid:String){
        let url = EndPoints.BASE_URL + "save/report"
        let param = ["post_id":postid]
        postWebCall(url: url, params: param, webCallName: "") { (response, error) in
            print(response)
            if !error{
                self.alert(message: "\(response["message"])")
                
            }else{
                
            }
        }
        
    }
}


enum VCType {
    case community
    case events
    case kikii
}
enum PostTypes{
    case myPosts
    case otherPosts
}
