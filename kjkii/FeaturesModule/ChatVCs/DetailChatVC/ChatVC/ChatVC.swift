//
//  ChatVC.swift
//  kjkii
//
//  Created by Shahbaz on 05/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import GrowingTextView
import Alamofire
import SwiftyJSON
import ProgressHUD
import FirebaseDatabase
import AVFoundation
import AVKit
import AgoraRtcKit
class ChatVC: UIViewController, UITextViewDelegate, ImagePickerDelegate, SelectedMsgDelegage,AgoraRtcEngineDelegate  {
    
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var containerview: UIView!
    @IBOutlet weak var audioMsgView: UIView!
    @IBOutlet var recordingTimeLabel: UILabel!
    
    var audioRecorder               : AVAudioRecorder!
    var audioPlayer                 : AVAudioPlayer!
    var meterTimer                  :Timer!
    var isAudioRecordingGranted     : Bool!
    var isRecording                 = false
    var isPlaying                   = false
    var agoraKit                        : AgoraRtcEngineKit!
    
    
    @IBOutlet weak var deletView        : UIView!
    @IBOutlet weak var sendImg          : UIImageView!
    @IBOutlet weak var newMessageText   : GrowingTextView!
    @IBOutlet weak var tblView          : UITableView!
    var imagePicker                     : ImagePicker!
    var dispatchGroup = DispatchGroup()
    var stTime = Date()
    
    var progressTimer:Timer?
    {
        willSet {
            progressTimer?.invalidate()
        }
    }
    
    var playerStream                    : AVPlayer?
    var playerItem: AVPlayerItem?
    var conversationID                  = String()
    var isChat                          = false
    var messages                        = JSON()
    var convID                          = ""
    var reciverID                       = String()
    var selectedIndex                   = Int()
    var otherUserFBID                   = String()
    var msgs                            = [FireBaseMessage]()
    var Lastmsgs                            = [FireBaseMessage]()
    var otherFBUser                     : OtherFBUSer?
    var isDeleting                      = false
    var deletingMsgIds                  = Set<String>()
    var player                          = AVPlayer()
    var chatKey = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteBtn.isHidden = true
        UIHelper.shared.popView(sender: self)
        tblView.register(UINib(nibName: "SentMsgCell", bundle: nil), forCellReuseIdentifier: "SentMsgCell")
        tblView.register(UINib(nibName: "RecMsg", bundle: nil), forCellReuseIdentifier: "RecMsg")
        tblView.delegate        = self
        tblView.dataSource      = self
        UIHelper.shared.addBanners(container: containerview, sender: self)
        tblView.backgroundColor = UIColor(named: "tblBack")!
        newMessageText.delegate = self
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
//        deletView.alpha = 0.0
        
        audioMsgView.isHidden = true
        check_record_permission()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getMessage()
    }
    
    
    @IBAction func audioBtnPressed(_ sender: Any) {
        
        let url = EndPoints.BASE_URL + "call"
        let param = ["type":"audio","user_id":otherFBUser!.id,"device_type":"ios"]
        postWebCall(url: url, params: param, webCallName: "") { (response, error) in
           if !error{
            print(response)
            let token = "\(response["token"])"
            let channel = "\(response["channel_name"])"
//            if DEFAULTS.string(forKey: "isPaid") != "0"{
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionsController") as! SubscriptionsController
//                vc.hidesBottomBarWhenPushed     = true
//
//                //vc.isVideo = false
//                self.navigationController?.pushViewController(vc, animated: true)
//            }else{
//                DEFAULTS.setValue(self.otherFBUser!.id, forKey: "uid")
//                DEFAULTS.setValue(token, forKey: "agoratoken")
//                DEFAULTS.setValue(channel, forKey: "agorachannel")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VoiceChatViewController") as! VoiceChatViewController
                vc.hidesBottomBarWhenPushed     = true
            vc.otherUserImage = self.otherFBUser!.image
            vc.otherUserName = self.otherFBUser!.userName
                vc.token = token
                vc.channel = channel
                //vc.isVideo = true
            vc.userID = self.otherFBUser!.id
                self.navigationController?.pushViewController(vc, animated: true)
           

           }else{
            self.alert(message: API_ERROR)
           }
        }
        
        
        
        
    }
    @IBAction func videoBtnPressed(_ sender: Any) {
        let url = EndPoints.BASE_URL + "call"
        let param = ["type":"video","user_id":otherFBUser!.id]
        postWebCall(url: url, params: param, webCallName: "") { (response, error) in
           if !error{
            print(response)
            let token = "\(response["token"])"
            let channel = "\(response["channel_name"])"
//            if DEFAULTS.string(forKey: "isPaid") != "0"{
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionsController") as! SubscriptionsController
//                vc.hidesBottomBarWhenPushed     = true
//                
//                //vc.isVideo = false
//                self.navigationController?.pushViewController(vc, animated: true)
//            }else{
//                DEFAULTS.setValue(self.otherFBUser!.id, forKey: "uid")
//                DEFAULTS.setValue(token, forKey: "agoratoken")
//                DEFAULTS.setValue(channel, forKey: "agorachannel")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoChatViewController") as! VideoChatViewController
                vc.hidesBottomBarWhenPushed     = true
                vc.token = token
                vc.channel = channel
                vc.isvideo = true
            vc.userID = self.otherFBUser!.id
            
                self.navigationController?.pushViewController(vc, animated: true)
            

           }else{
            self.alert(message: API_ERROR)
           }
        }
        
        
    }
    
    func getMessage(){
        ProgressHUD.show()
        self.newMessageText.text = ""
        Common.shared.getUserFBID(otherUserID: conversationID) { [weak self](key) in
            guard let self = self else {return}
            self.otherUserFBID = key
            Common.shared.getOtherUser(id: key) { (user) in
                if let user = user{
                    self.otherFBUser = user
                    self.chat()
                }
            }
            
        }
    }
    
    
    func chat(){
        
        let myString = DEFAULTS.string(forKey: "FBID")! + "___" + self.otherUserFBID
        chatKey = myString
        Database.database().reference().child("Chats").observe(.value) { (data) in
            self.msgs.removeAll()
            for child in data.children
            {
                let msg = child as! DataSnapshot
                if msg.key == myString{
                    for a in msg.children{
                        let innerMsg = a as! DataSnapshot
                        let val = innerMsg.value! as! [String:Any]
                        self.msgs.append(FireBaseMessage(deviceType: "\(val["deviceType"] ?? "")",
                                                         message: "\(val["message"]!)",
                                                         messageBy: "\(val["messageBy"]!)",
                                                         recordingTime: "\(val["recordingTime"]!)",
                                                         seen: "\(val["seen"]!)",
                                                         time: "\(val["time"]!)",
                                                         type: "\(val["type"]!)",
                                                         userId: "\(val["userId"]!)", isSelected: false, messageId: "\(val["messageId"]!)"))
                    }
                }
            }
            ProgressHUD.dismiss()
            self.tblView.reloadData()
            DispatchQueue.main.async {
                if self.msgs.count > 1{
                    let indexPath = IndexPath(row: self.msgs.count-1, section: 0)
                    self.tblView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
                
            }
        }
    }
    
    
    func getChatMsgs(){
        let url = EndPoints.BASE_URL + "conversation/messages?user_match_id=\(conversationID)"
        let param = ["":""]
        getWebCall(url: url, params: param, webCallName: "Getting Chat Messages", sender: self) { (response, error) in
            let messages    = response["messages"]
            self.messages   = messages
            let conID       = "\(messages[0]["conversation_id"])"
            if conID != "null" {
                self.convID = conID
            }
            self.tblView.reloadData()
        }
    }
    
    func getConversationMsgs(){
        let url = EndPoints.BASE_URL + "conversation/messages?conversation_id=\(conversationID)"
        let param = ["":""]
        getWebCall(url: url, params: param, webCallName: "Getting Chat Messages", sender: self) { [unowned self] (response, error) in
            let messages    = response["messages"]
            self.messages   = messages
            self.tblView.reloadData()
        }
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        let text = textView.text!
        if text.count > 0 {
            sendImg.image = UIImage(named: "snedMsg")
        }
        else{
            sendImg.image = UIImage(named: "mic")
        }
    }
    
    @IBAction func sendMsgBtn(_ sender: Any)
    {
        let text = newMessageText.text!
        if text.count > 0 {
            Common.shared.postMsg(msg: text, ohterFBID: otherUserFBID)
            self.newMessageText.text = ""
        }
        else{
            start_recording()
        }
    }
    
    @IBAction func addBtnPressed(_ sender: Any)
    {
        self.imagePicker.present(from: view)
    }
    
    @IBAction func menuBtnTpd(_ sender: Any) {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "View Profile", style: .default) { [self] action -> Void in
            print("Go to profile page")
            let vc = ProfileVC(nibName: "ProfileVC", bundle: nil)
            vc.hidesBottomBarWhenPushed = true
            vc.id = self.conversationID
            vc.isOtherProfile = true
            self.navigationController?.pushViewController(vc, animated: true)
          
        }

       

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }

        // add actions
        actionSheetController.addAction(firstAction)
      
        actionSheetController.addAction(cancelAction)

        present(actionSheetController, animated: true) {
            print("option menu presented")
        }
    }
    
    
    
}
extension ChatVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return msgs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if "\(msgs[indexPath.row].messageBy)" == DEFAULTS.string(forKey: "FBID")!
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SentMsgCell") as! SentMsgCell
            cell.configCell(item: msgs[indexPath.row], row: indexPath.row)
            cell.delegate = self
            if indexPath.row > 0 {
                if msgs[indexPath.row - 1].messageBy == msgs[indexPath.row].messageBy{
                    cell.heightsToZero.forEach({$0.constant = 0})
                    cell.lblsToClear.forEach({$0.text = ""})
                    cell.viewToHide.forEach({$0.isHidden = true})
                }
                else{
                    cell.heightsToZero.forEach({$0.constant = 25})
                    cell.viewToHide.forEach({$0.isHidden = false})
                }
            }
            else{
                cell.heightsToZero.forEach({$0.constant = 25})
                cell.viewToHide.forEach({$0.isHidden = false})
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecMsg") as! RecMsg
            if let other = otherFBUser{
                cell.configCell(item: msgs[indexPath.row], other: other, row: indexPath.row)
                cell.delegate = self
                
                //                cell.heightsToZero.forEach({$0.constant = 0})
                //                cell.lblsToClear.forEach({$0.text = ""})
                //                cell.viewToHide.forEach({$0.isHidden = true})
                
                
                if indexPath.row > 0 {
                    if msgs[indexPath.row - 1].messageBy == msgs[indexPath.row].messageBy{
                        cell.heightsToZero.forEach({$0.constant = 0})
                        cell.lblsToClear.forEach({$0.text = ""})
                        cell.viewToHide.forEach({$0.isHidden = true})
                    }
                    else{
                        cell.heightsToZero.forEach({$0.constant = 25})
                        cell.viewToHide.forEach({$0.isHidden = false})
                    }
                }
                else{
                    cell.heightsToZero.forEach({$0.constant = 25})
                    cell.viewToHide.forEach({$0.isHidden = false})
                }
                
            }
            
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        if isDeleting {
            if deletingMsgIds.count > 0 {
                if msgs[indexPath.row].isSelected{
                    msgs[indexPath.row].isSelected = false
                    deletingMsgIds.remove(msgs[indexPath.row].messageId)
                }
                else{
                    msgs[indexPath.row].isSelected = true
                    deletingMsgIds.insert(msgs[indexPath.row].messageId)
                }
                
            }
            else {
                
                deletingMsgIds.removeAll()
                isDeleting = false
            }
            
            if deletingMsgIds.count == 0{
                self.deletView.alpha = 0.0
            }
            tblView.reloadData()
        }
        else{
            if msgs[indexPath.row].type == "video"{
                playVideo(url: msgs[indexPath.row].message)
            }
        }
        tblView.reloadData()
        
    }
    
    func deleteMsg()
    {
        
        let url = EndPoints.BASE_URL + "delete/message/\(messages[selectedIndex]["id"])"
        deleteWebCall(url: url, params: ["":""], webCallName: "deleteing Message", sender: self) { [unowned self] (response, error) in
            if !error
            {
                let success = "\(response["success"])"
                if success == "true"{
                    self.getMessage()
                }
            }
            else {
                self.alert(message: API_ERROR)
            }
        }
    }
    
    
    
    func playVideo(url : String){
        guard let videoURL = URL(string: url) else {
            return
        }
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
    
    
    func selectedMsgs(row: Int) {
        deleteBtn.isHidden = false
        if !isDeleting{
            isDeleting              = true
            if msgs[row].isSelected{
                msgs[row].isSelected = false
            }
            else{
                msgs[row].isSelected = true
            }
            UIView.animate(withDuration: 0.5) {
                self.deletView.alpha = 1.0
            }
            deletingMsgIds.insert(msgs[row].messageId)
            tblView.reloadData()
        }
        
    }
    
    func video(url: URL?) {
        if let url = url {
            ProgressHUD.show()
            Common.shared.postMsgWithVideo(url: url, otherFBID: otherUserFBID)
        }
    }
    
    func didSelect(image: UIImage?) {
        if let img = image{
            Common.shared.postMsgWithImage(img: img, otherFBID: otherUserFBID)
        }
    }
    
    @IBAction func deleteMsgs(_ sender: Any) {
        for key in deletingMsgIds{
            let myString = DEFAULTS.string(forKey: "FBID")! + "___" + otherUserFBID
            
            let otherString =  otherUserFBID + "___" + DEFAULTS.string(forKey: "FBID")!
            Database.database().reference().child("Chats").child(myString).child(key).setValue(nil)
            Database.database().reference().child("Chats").child(otherString).child(key).setValue(nil)
        }
        
                 self.isDeleting = false
                 self.deletView.isHidden = true
                 self.deleteBtn.isHidden = true
        let myString = DEFAULTS.string(forKey: "FBID")! + "___" + otherUserFBID
         let otherString =  otherUserFBID + "___" + DEFAULTS.string(forKey: "FBID")!
        self.firstTask { (success) -> Void in
            if success {
                // do second task if success
                
              
       
                let last = self.Lastmsgs.count - 1
                let lastMessage = self.Lastmsgs[last]
        if lastMessage.type == "audio"{
            let lstMsg = ["deviceType":"iOS",
                          "message":"audio",
                          "messageBy":"\(DEFAULTS.string(forKey: "FBID")!)",
                          "recordingTime":0,
                          "seen":"true",
                          "time":Date().millisecondsSince1970,
                          "type":"audio",
                          "userId":"\(DEFAULTS.string(forKey: "FBID")!)"] as [String : Any]
            Database.database().reference().child("LastMessages").child(myString).setValue(lstMsg)
            Database.database().reference().child("LastMessages").child(otherString).setValue(lstMsg)
        } else if lastMessage.type == "image"{
            let lstMsg = ["deviceType":"iOS",
                          "message":"audio",
                          "messageBy":"\(DEFAULTS.string(forKey: "FBID")!)",
                          "recordingTime":0,
                          "seen":"true",
                          "time":Date().millisecondsSince1970,
                          "type":"image",
                          "userId":"\(DEFAULTS.string(forKey: "FBID")!)"] as [String : Any]
            Database.database().reference().child("LastMessages").child(myString).setValue(lstMsg)
            Database.database().reference().child("LastMessages").child(otherString).setValue(lstMsg)
            
        } else if lastMessage.type == "video"{
            let lstMsg = ["deviceType":"iOS",
                          "message":"audio",
                          "messageBy":"\(DEFAULTS.string(forKey: "FBID")!)",
                          "recordingTime":0,
                          "seen":"true",
                          "time":Date().millisecondsSince1970,
                          "type":"video",
                          "userId":"\(DEFAULTS.string(forKey: "FBID")!)"] as [String : Any]
            Database.database().reference().child("LastMessages").child(myString).setValue(lstMsg)
            Database.database().reference().child("LastMessages").child(otherString).setValue(lstMsg)
            
        } else if lastMessage.type == "text"{
           
            Database.database().reference().child("LastMessages").child(myString).setValue(lastMessage)
            Database.database().reference().child("LastMessages").child(otherString).setValue(lastMessage)
            
        }
       
       
            }
        }
    }

    func firstTask(completion: @escaping(_ success: Bool) -> Void) {
        // Do something
        
        let myString = DEFAULTS.string(forKey: "FBID")! + "___" + self.otherUserFBID
        chatKey = myString
        Database.database().reference().child("Chats").observe(.value) { (data) in
           
            for child in data.children
            {
                let msg = child as! DataSnapshot
                if msg.key == myString{
                    for a in msg.children{
                        let innerMsg = a as! DataSnapshot
                        let val = innerMsg.value! as! [String:Any]
                        self.Lastmsgs.append(FireBaseMessage(deviceType: "\(val["deviceType"] ?? "")",
                                                         message: "\(val["message"]!)",
                                                         messageBy: "\(val["messageBy"]!)",
                                                         recordingTime: "\(val["recordingTime"]!)",
                                                         seen: "\(val["seen"]!)",
                                                         time: "\(val["time"]!)",
                                                         type: "\(val["type"]!)",
                                                         userId: "\(val["userId"]!)", isSelected: false, messageId: "\(val["messageId"]!)"))
                    }
                }
            }
           
            completion(true)
    }
        // Call completion, when finished, success or faliure
       
    }
}


extension ChatVC: AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    
    
    func check_record_permission()
    {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSessionRecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSessionRecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSessionRecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                }
            })
            break
        default:
            break
        }
    }
    
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getFileUrl() -> URL {
        let filename = "myName.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    func setup_recorder()
    {
        if isAudioRecordingGranted
        {
            let session = AVAudioSession.sharedInstance()
            do
            {
                try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 12000,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            }
            catch let error {
                display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
            }
        }
        else
        {
            display_alert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK")
        }
    }
    
    func start_recording()
    {
        if(isRecording)
        {
            newMessageText.isUserInteractionEnabled = false
            isRecording = false
            let endTime = Date()
            let timeIntval = Int(DateInterval(start: stTime, end: endTime).duration * 1000)
            Common.shared.postMsgWithAudio(url: getFileUrl(), otherFBID: otherUserFBID, recordingTime : "\(timeIntval)")
            stopRecording()
            finishAudioRecording(success: true)
        }
        else
        {
            stTime = Date()
            sendImg.image = UIImage(named: "snedMsg")
            setup_recorder()
            let session = AVAudioSession.sharedInstance()
            do
            {
                try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 12000,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                
                print("Here.a.. ")
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            }
            catch let error {
                display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
            }
            audioRecorder.record()
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
            audioMsgView.isHidden = false
            newMessageText.isUserInteractionEnabled = true
            newMessageText.text = ""
            isRecording = true
        }
    }
    
    @objc func updateAudioMeter(timer: Timer)
    {
        if audioRecorder.isRecording
        {
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            //            newMessageText.text = totalTimeString
            recordingTimeLabel.text = totalTimeString
            audioRecorder.updateMeters()
        }
    }
    
    func finishAudioRecording(success: Bool)
    {
        if success
        {
            
        }
        else
        {
            display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
        }
    }
    
    func prepare_play()
    {
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        }
        catch{
            print("Error")
        }
    }
    
    @IBAction func stopRecordingBtnPressed(_ sender: Any) {
        stopRecording()
    }
    
    func stopRecording() {
        isRecording             = false
        audioRecorder.stop()
        audioRecorder           = nil
        meterTimer.invalidate()
        newMessageText.isUserInteractionEnabled = false
        audioMsgView.isHidden   = true
        sendImg.image           = UIImage(named: "mic")
    }
    
    
    @IBAction func play_recording(_ sender: Any)
    {
        self.imagePicker.present(from: sender as! UIView)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if !flag
        {
            finishAudioRecording(success: false)
        }
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
        audioMsgView.isHidden = true
    }
    
    func display_alert(msg_title : String , msg_desc : String ,action_title : String)
    {
        let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: action_title, style: .default)
        {
            (result : UIAlertAction) -> Void in
            _ = self.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
    }
    
}
