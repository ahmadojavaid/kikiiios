//
//  MatchProfileVC.swift
//  kjkii
//
//  Created by Mazhar on 2021-03-24.
//  Copyright © 2021 abbas. All rights reserved.
//

import UIKit
import Lottie
import FirebaseDatabase

class MatchProfileVC: UIViewController {
    var timer: Timer?

    @IBOutlet weak var animationView: AnimationView!
    var selectedMatchId = String()
    
    @IBOutlet weak var imgVu2: UIImageView!
    @IBOutlet weak var imgVu1: UIImageView!
//    private var animationView: AnimationView?
    var profileImage1 = ""
    var id = String()
    var item: MeetUsers?
    var inbox = [InboxFbMsgs]()
    override func viewDidLoad() {
        super.viewDidLoad()
        UIHelper.shared.setImage(address: profileImage1, imgView: imgVu1)
        getProfile()
       }
   
    override func viewDidAppear(_ animated: Bool) {
        // 1. Set animation content mode
         
         animationView.contentMode = .scaleAspectFit
         
         // 2. Set animation loop mode
         
         animationView.loopMode = .loop
         
         // 3. Adjust animation speed
         
         animationView.animationSpeed = 0.5
         
         // 4. Play animation
         animationView.play()
       
    }
   
    @IBAction func startChatBtnTpd(_ sender: Any) {
        animationView.stop()
        print("start button tapped")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        vc.conversationID = selectedMatchId
        vc.hidesBottomBarWhenPushed = true
        vc.isChat = true
        self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func crossBtnTpd(_ sender: Any) {
        animationView.stop()
        self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)

       
    }
   
    func getProfile(){
        let userID = GetProfile(id: id)
        userID.getProfile {[weak self] (result) in
            guard let self = self else {return}
            switch result{
            case .success(let data):
                if data.success ?? false {
                    self.item = data.user!
                    UIHelper.shared.setImage(address: (data.user?.profile_pic)!, imgView: self.imgVu2)
                    
                }
                else{
                    self.alert(message: data.message ?? API_ERROR)
                }
            case .failure(let error):
                self.alert(message: error.rawValue)
            }
        }
    }
//    func getInboxFromFB(){
//        Database.database().reference().child("LastMessages").observe(.value) { [weak self](data) in
//            guard let self = self else {return}
//            self.inbox.removeAll()
//            for child in data.children
//            {
//                let msg = child as! DataSnapshot
//                let val = msg.value! as! [String:Any]
//                let key = msg.key.components(separatedBy: "___")
//                if key.first == DEFAULTS.string(forKey: "FBID")!
//                {
//                    self.inbox.append(InboxFbMsgs(userName: "", userId: key.last!, message: "\(val["message"] ?? "")", time: "\(val["time"] ?? "0.0")", img: "", id: ""))
//                }
//            }
//            for i in 0..<self.inbox.count{
//                self.userRef.observe(.value) { [weak self] (data) in
//                    guard let self = self else {return}
//                    for child in data.children{
//                        let msg = child as! DataSnapshot
//                        let val = msg.value! as! [String:Any]
//                        if msg.key == self.inbox[i].userId{
//                            self.inbox[i].userName  = "\(val["userName"]!)"
//                            self.inbox[i].img       = "\(val["image"]!)"
//                            self.inbox[i].id        = "\(val["id"]!)"
//                        }
//                    }
//                    self.tblView.reloadData()
//                }
//            }
//        }
//
//
//
//    }
    
}
