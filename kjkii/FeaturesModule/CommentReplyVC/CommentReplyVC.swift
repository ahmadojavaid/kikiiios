//
//  CommentReplyVC.swift
//  kjkii
//
//  Created by Shahbaz on 16/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import GrowingTextView

class CommentReplyVC: UIViewController {

    @IBOutlet weak var backgroundVu: VariableCornerRadiusView!
    @IBOutlet weak var newCommentText: GrowingTextView!
    @IBOutlet weak var tblVIew: UITableView!
    var comment : Comments?
    var replies = [Replies]()
    override func viewDidLoad() {
        super.viewDidLoad()
        UIHelper.shared.setupTable(nibName: "MainCommentCell", tbl: tblVIew)
        UIHelper.shared.setupTable(nibName: "CommentReplyCell", tbl: tblVIew)
        tblVIew.delegate = self
        tblVIew.dataSource = self
        tblVIew.estimatedSectionHeaderHeight = 100
        tblVIew.sectionHeaderHeight = UITableView.automaticDimension
        self.definesPresentationContext = true
//        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
    }
    
    @IBAction func commentBtnPressed(_ sender: Any)
    {
        let text = newCommentText.text!
        if text.count > 0{
            showProgress(sender: self)
            let reply = CommentOnReply(comment_id: "\(comment!.id ?? 0)", body: text)
            reply.addComment { [unowned self] (result) in
                dismisProgress()
                switch result{
                case .success(let data):
                    print("**********")
                    print(data)
                    if data.success ?? false {
                        self.replies.insert(data.comment!, at: 0)
                        self.tblVIew.reloadData()
                        NotificationCenter.default.post(name: NSNotification.Name("commentPosted"), object: nil)
//                        self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func backgroundBtnTpd(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension CommentReplyVC : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCommentCell") as! MainCommentCell
        cell.configMainComment(item: comment!)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentReplyCell") as! CommentReplyCell
        cell.configCell(item: replies[indexPath.row])
        return cell
    }
    
    
}
