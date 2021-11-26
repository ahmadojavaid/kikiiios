//
//  CommunityDetailVC.swift
//  kjkii
//
//  Created by Shahbaz on 07/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import GrowingTextView
class  CommunityDetailVC: UIViewController {
    
    @IBOutlet weak var commentText: GrowingTextView!
    @IBOutlet weak var tblView: UITableView!
    
    var post        : Posts?
    var comments    = [Comments]()
    var kiki        = false
    var kikiPost    : KiPosts?
    var tag         = Int()
    var singlePost        : SinglePOst?
    var singlePostID = "147"
    var isUpdate = false
    var comefromDeepLink = false
    override func viewDidLoad() {
        super.viewDidLoad()
        UIHelper.shared.setupTable(nibName: "CommunityCell", tbl: tblView)
        UIHelper.shared.popView(sender: self)
        UIHelper.shared.setupTable(nibName: "CommunityChatCell", tbl: tblView)
        tblView.register(UINib(nibName: "KikiiCell", bundle: nil), forCellReuseIdentifier: "KikiiCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(getComments), name: NSNotification.Name("commentPosted"), object: nil)
        if comefromDeepLink{
            getSinglePost()
        }else{
            tblView.delegate    = self
            tblView.dataSource  = self
            getComments()
        }
       
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any)
    {
        comefromDeepLink = false
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func getComments(){
        showProgress(sender: self)
        var post_id = kiki ? kikiPost?.id ?? 0 : post?.id ?? 0
        if comefromDeepLink{
            post_id = Int(singlePostID)!
        }
        let id = PostComments(post_id: "\(post_id)")
        id.getComments { [unowned self](result) in
            dismisProgress()
            
            switch result{
            case .success(let data):
                if data.success ?? false{
                    if let comments = data.comments{
                        self.comments = comments
                    }
                    self.tblView.reloadData()
                    self.scrollToBottom()
                }
                else{
                    self.alert(message: data.message ?? API_ERROR)
                }
            case .failure(let error):
                self.alert(message: error.rawValue)
            }
        }
    }
    
    @IBAction func sendMsgBtn(_ sender: Any)
    {
        if isUpdate{
            self.updateCommet()
        }else{
            let text = commentText.text!
            if text.count > 0{
                showProgress(sender: self)
                var post_id = kiki ? kikiPost?.id ?? 0 : post?.id ?? 0
                if comefromDeepLink{
                    post_id = Int(singlePostID)!
                }
                let comment = PostNewComment(post_id: "\(post_id)", body: text)
                comment.postComment { [unowned self](result) in
                    dismisProgress()
                    switch result{
                    case .success(let data):
                        if data.success{
                            self.comments.append(data.comment)
                            self.tblView.reloadData()
                            self.commentText.text = ""
                            self.scrollToBottom()
                        }
                    case .failure(let error):
                        self.alert(message: error.rawValue)
                    }
                }
            }
        }
        
    }
    
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.comments.count > 1{
                let indexPath = IndexPath(row: self.comments.count, section: 0)
                self.tblView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            
        }
    }
    
    
    @objc func showCommentReplies(_ sender: UIButton){
        let vc = CommentReplyVC(nibName: "CommentReplyVC", bundle: nil)
        vc.comment = comments[sender.tag]
        if let replies = comments[sender.tag].replies{
            vc.replies = replies
        }
//        self.present(vc, animated: true, completion: nil)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    
}

extension CommunityDetailVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0{
            if kiki{
                let cell = tableView.dequeueReusableCell(withIdentifier: "KikiiCell") as! KikiiCell
                cell.configCell(item: kikiPost!)
                cell.countView.isHidden = true
                cell.countViewHeight.constant = 0.0
                
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityCell") as! CommunityCell
            if comefromDeepLink{
                cell.config(item: singlePost!.post)
            }else{
            cell.config(item: post!)
            }
            cell.commentBtn.isHidden = true
            cell.commentBtn.isHidden = true
            cell.commentBtnView.isHidden = true
            cell.viewHeight.constant = 0.0
           
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityChatCell") as! CommunityChatCell
            cell.configCell(item: comments[indexPath.row - 1])
            cell.replyBtn.tag = indexPath.row - 1
            cell.replyBtn.addTarget(self, action: #selector(showCommentReplies(_:)), for: .touchUpInside)
            cell.moreBtn.tag = indexPath.row - 1
            cell.moreBtn.addTarget(self, action: #selector(moreBtnPressed(_:)), for: .touchUpInside)
           
            return cell
        }
    }
    
    
    @objc func moreBtnPressed(_ sender: UIButton){
        tag = sender.tag
        if CurrentUser.userData()!.id == comments[sender.tag].user?.id ?? 0{
            showActionSheet(myPost: true)
        }
        else{
            showActionSheet(myPost: false)
        }
    }
   
    
    
    
    func showActionSheet(myPost: Bool){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if myPost{
            let defaultAction = UIAlertAction(title: "Delete", style: .destructive, handler: { [unowned self](alert: UIAlertAction!) -> Void in
                self.deleteCommet()
            })
            alertController.addAction(defaultAction)
            let updateAction = UIAlertAction(title: "Update", style: .destructive, handler: { [unowned self](alert: UIAlertAction!) -> Void in
                isUpdate = true
                commentText.text = comments[tag].body
            })
            alertController.addAction(updateAction)
        }else{
            let deleteAction = UIAlertAction(title: "Report", style: .default, handler: {[unowned self] (alert: UIAlertAction!) -> Void in
                self.reportComment()
            })
            alertController.addAction(deleteAction)
        }
        
        
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            //  Do something here upon cancellation.
        })
        
        
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func deleteCommet(){
        showProgress(sender: self)
        let comment_id = DeleteComment(id: "\(comments[tag].id ?? 0)")
        comment_id.delete { [weak self](done) in
            guard let self = self else {return}
            dismisProgress()
            if done{
                DispatchQueue.main.async {
                    
                
                self.comments.remove(at: self.tag)
                self.tblView.reloadData()
                }
            }
            else
            {
                self.alert(message: API_ERROR)
            }
        }
        
    }
    func updateCommet(){
        let commentbody = commentText.text!
        let url = EndPoints.BASE_URL + "update/comment/" + "\(comments[tag].id!)"
        let param = ["body":commentbody,"post_id":"\(comments[tag].post_id!)"]
        postWebCall(url: url, params: param, webCallName: "") { (response, error) in
            print(response)
            if !error{
                self.isUpdate = false
                self.commentText.text = ""
                self.commentText.placeholder = "Say Sopmething..."
                
                self.getComments()
//                oneStepBackPopUp(msg: "\(response["message"])", sender: self)

            }else{

            }
        }
        
    }
    
    func reportComment(){
        print("\(comments[tag].id ?? 0)")
        let url = EndPoints.BASE_URL + "save/report"
        let param = ["comment_id":"\(comments[tag].id ?? 0)"]
        postWebCall(url: url, params: param, webCallName: "") { (response, error) in
            print(response)
            if !error{
                self.alert(message: "\(response["message"])")

            }else{

            }
        }
        
    }
    func getSinglePost(){
        let url = BASE_URL + "post?" + "id=" + singlePostID
       let finalURL = URL(string:url)!
        
        let logindata = [
                          
               "id": singlePostID ,
               
                   ] as [String : String]

        getSinglePostData(param: logindata, url: finalURL, onSuccess: { [self] (status, msg, res) in
              
//              let parseRes = ApiManager.responseParsingOrderHistory(result: res)
            
//            self.OrdersData = parseRes
            
            let jsonString = jsonToString(jsonTOConvert: res)
             let jsonData = jsonString.data(using: .utf8)
            
            let blogPosts: SinglePOst = try! JSONDecoder().decode(SinglePOst.self, from: jsonData!)
          print(blogPosts)
            singlePost = blogPosts
            tblView.delegate    = self
            tblView.dataSource  = self
            getComments()
            
            
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
