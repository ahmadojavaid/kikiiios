//
//  YourMatchVC.swift
//  kjkii
//
//  Created by Shahbaz on 26/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
class YourMatchVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var backImgVu: UIImageView!
    var comeFromNoti = false
    
    var likes       = [Likes]()
    var matches     = [Matches]()
    @IBOutlet weak var containerView: UIView!
    var selectedMatchId = String()
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.isHidden = true
        backImgVu.isHidden = true
        UIHelper.shared.setupTable(nibName: "YourMatchesCell", tbl: tblView)
        UIHelper.shared.setupTable(nibName: "LikeCell", tbl: tblView)
        tblView.delegate = self
        tblView.dataSource = self
        UIHelper.shared.addBanners(container: containerView, sender: self)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if comeFromNoti{
            backBtn.isHidden = false
            backImgVu.isHidden = false
        }
        getMatch()
    }
    
    
    @IBAction func backBtnTpd(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getMatch(){
        showProgress(sender: self)
        GetYourMatch.shared.getMatches { [unowned self] (result) in
            dismisProgress()
            switch result{
            case .success(let data):
                if let likes = data.likes{
                    self.likes = likes
                }
                if let matches = data.matches{
                    self.matches = matches
                    
                }
                self.tblView.reloadData()
            case .failure(let error):
                self.alert(message: error.rawValue)
            }
        }
    }
}

extension YourMatchVC : UITableViewDelegate, UITableViewDataSource, MatchSelectedDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.row == 0
        {
            let cell = tblView.dequeueReusableCell(withIdentifier: "LikeCell") as! LikeCell
            cell.configCell(likes: self.likes)
            return cell
        }
        else{
            let cell = tblView.dequeueReusableCell(withIdentifier: "YourMatchesCell") as! YourMatchesCell
            cell.delegate = self
            cell.configCell(matches: self.matches)
            return cell
        }
    }
    
    
    func matchSelected(id: String) {
        self.selectedMatchId = id
        moreActions()
        
    }
    func moreActions(){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Send Message", style: .default, handler: {
            action in
            self.gotoChat()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "View Profile", style: .default, handler: {
            action in
            let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            vc.id = self.selectedMatchId
            vc.isOtherProfile = true
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            print("third button")
        }))
        actionSheet.popoverPresentationController?.sourceView = self.view
        actionSheet.popoverPresentationController?.sourceRect = self.view.frame
        present(actionSheet, animated: true, completion: nil)
    }
    
    
    func gotoChat(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.conversationID = selectedMatchId
        vc.hidesBottomBarWhenPushed = true
        vc.isChat = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
  
   
    
}
