//
//  VoiceChatViewController.swift
//  kjkii
//
//  Created by Saeed Rehman on 12/01/2021.
//  Copyright © 2021 abbas. All rights reserved.
//

import UIKit
import AgoraRtcKit
class VoiceChatViewController: UIViewController {
    
    @IBOutlet weak var endCallBtn: UIButton!
    @IBOutlet weak var callAcceptBtn: UIButton!
    @IBOutlet weak var callDeclineBtn: UIButton!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var userImgVu: UIImageView!
    
    @IBOutlet weak var userNameLbl: UILabel!
    
    @IBOutlet weak var controlButtonsView: UIView!
    var player: AVAudioPlayer?

    var isAccepted = false
    var userID = ""
  var otherUserImage = ""
    var otherUserName = ""
    var otherUserImageNoti = ""
      var otherUserNameNoti = ""
    var timer = Timer()
    var secSpent = 0
    var comeFromNotification = false
    
    var agoraKit: AgoraRtcEngineKit!
    var token = String()
    var channel = String()
    var uid = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        userImgVu.layer.borderWidth = 1
        userImgVu.layer.masksToBounds = false
        userImgVu.layer.borderColor = UIColor.black.cgColor
        userImgVu.layer.cornerRadius = userImgVu.frame.height/2
        userImgVu.clipsToBounds = true
        if comeFromNotification == false{
            playSound(tuneName: "SendingTone")
        UIHelper.shared.setImage(address: otherUserImage, imgView: userImgVu)
        userNameLbl.text = otherUserName
//        agoraKit.delegate = self
        
        initializeAgoraEngine()
        joinChannel()
            callAcceptBtn.isHidden = true
            callDeclineBtn.isHidden = true
        }else{
            playSound(tuneName: "ReceivingTone")
            UIHelper.shared.setImage(address: otherUserImageNoti, imgView: userImgVu)
            userNameLbl.text = otherUserNameNoti
            callAcceptBtn.isHidden = false
             callDeclineBtn.isHidden = false
            endCallBtn.isHidden = true
        }
        NotificationCenter.default.addObserver(self, selector: #selector(Call), name: NSNotification.Name(rawValue: "CALLNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.missedCall(_:)), name: NSNotification.Name(rawValue: "missedCall"), object: nil)
        
    }
    @objc func missedCall(_ sender: NSNotification){
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    @objc func Call(_ sender: NSNotification){
        
//        let token = sender.userInfo?["Token"] as? String
//        let channel = sender.userInfo?["Channel"] as? String
//        let type = sender.userInfo?["Type"] as? String
//        if type == "video"{
//            let stb = UIStoryboard(name: "Main", bundle: nil)
//            let vc = stb.instantiateViewController(withIdentifier: "VideoChatViewController") as! VideoChatViewController
//            vc.token = token ?? ""
//            vc.channel = channel ?? ""
//            vc.isvideo = true
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
//        }else{
//            let stb = UIStoryboard(name: "Main", bundle: nil)
//            let vc = stb.instantiateViewController(withIdentifier: "VoiceChatViewController") as! VoiceChatViewController
//            vc.token = token ?? ""
//            vc.channel = channel ?? ""
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        
        UIHelper.shared.setImage(address: otherUserImage, imgView: userImgVu)
        userNameLbl.text = otherUserName

        
       
            callAcceptBtn.isHidden = false
            callDeclineBtn.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        token = DEFAULTS.string(forKey: "agoratoken")!
//        channel = DEFAULTS.string(forKey: "agorachannel")!
//        uid = Int(DEFAULTS.string(forKey: "uid")!)!
        print("videofromtoken")
        print(token)
        print(channel)
        print(uid)
    }
    func startCallTimer(timeInterval : Double){
        // start the timer
       
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(timerCallAction), userInfo: nil, repeats: false)
    }
    @objc func timerCallAction() {
      
            self.secSpent += 1
            let (h,m,s) = self.secondsToHoursMinutesSeconds(seconds: self.secSpent)
            
            var min = ""
            var hour = ""
            var sec = ""
            
            if(m >= 0 && m <= 9){
                min = "0\(m)"
            }else{
                min = "\(m)"
            }
            
            if(h >= 0 && h <= 9){
                hour = "0\(h)"
            }else{
                hour = "\(h)"
            }
            
            if(s >= 0 && s <= 9){
                sec = "0\(s)"
            }else{
                sec = "\(s)"
            }
            
        timerLbl.text = "\(min):\(sec)"
            //                print("\(m):\(s)")
            //                timeCount += 1
            startCallTimer(timeInterval: 1.0)
        }
        
    
    
    func resetTimer(){
        timer.invalidate()
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @IBAction func callAcceptBtnTpd(_ sender: Any) {
        callAcceptBtn.isHidden = true
        callDeclineBtn.isHidden = true
        endCallBtn.isHidden = false
        player?.stop()
        initializeAgoraEngine()
        joinChannel()
    }
    
    @IBAction func callDeclinedBtnTpd(_ sender: Any) {
        player?.stop()
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    func playSound(tuneName: String) {
        guard let url = Bundle.main.url(forResource: tuneName, withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()
            player.numberOfLoops = 6

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    func initializeAgoraEngine() {
        // Initializes the Agora engine with your app ID.
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AgoraPoints.AppID, delegate: self)
    }
    
    func joinChannel() {
        // Allows a user to join a channel.
        agoraKit.joinChannel(byToken: token, channelId: channel, info:nil, uid:0) {[unowned self] (sid, uid, elapsed) -> Void in
            // Joined channel "demoChannel"
//            self.agoraKit.setEnableSpeakerphone(true)
            
            UIApplication.shared.isIdleTimerDisabled = true
//            startCallTimer(timeInterval: 1.0)
            
        }
       
        
    }
    
    @IBAction func didClickHangUpButton(_ sender: UIButton) {
        leaveChannel()
        if isAccepted{
            isAccepted = false
        }else{
          missedCallNotification()
        }
    }
    func missedCallNotification(){
        let url = BASE_URL + "missed-call-notification"
//        let url = "https://kikii.uk/api/update/profile"
        let params =
            [        "user_id": userID,
                     "type":"audio"
                     
            ]
        
        print(params)
        postWebCall(url: url, params: params, webCallName: "missedCallNotification") { (response, error)  in
            if !error{
//                DispatchQueue.main.async {
//                   print("Account upgraded")
//                DEFAULTS.setValue("1", forKey: PurchasedStates.purchased)
//                oneStepBackPopUp(msg: "Account has been upgraded", sender: self)
                }
                else{
                   print("")
//                    self.alert(message: API_ERROR)
                }
        
            
    
    }
    }
    
    func leaveChannel() {
        agoraKit.leaveChannel(nil)
//        hideControlButtons()
        UIApplication.shared.isIdleTimerDisabled = false
        resetTimer()
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func hideControlButtons() {
        controlButtonsView.isHidden = true
    }
    
    @IBAction func didClickMuteButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        // Stops/Resumes sending the local audio stream.
        agoraKit.muteLocalAudioStream(sender.isSelected)
    }
    
    @IBAction func didClickSwitchSpeakerButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        // Enables/Disables the audio playback route to the speakerphone.
        //
        // This method sets whether the audio is routed to the speakerphone or earpiece. After calling this method, the SDK returns the onAudioRouteChanged callback to indicate the changes.
        agoraKit.setEnableSpeakerphone(sender.isSelected)
    }
}
extension VoiceChatViewController: AgoraRtcEngineDelegate {

  
    
    func rtcEngineConnectionDidInterrupted(_ engine: AgoraRtcEngineKit) {
       print("conection interupted")
    }
    
    /** Occurs when the SDK cannot reconnect to Agora's edge server 10 seconds after its connection to the server is interrupted.
    *  See the description above to compare this method to rtcEngineConnectionDidInterrupted.
    *
    * @param engine AgoraRtcEngineKit object.
    */
    func rtcEngineConnectionDidLost(_ engine: AgoraRtcEngineKit) {
      print("connection lost")
    }
    
   
   
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
      print("error")
    }
   
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
       print("did joined channel")
       
    }
    
   
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("")
        callAcceptBtn.isHidden = true
        callDeclineBtn.isHidden = true
        isAccepted = true
           player?.stop()
        startCallTimer(timeInterval: 1.0)
       
    }
    
   
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        print("")
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
  
    func rtcEngine(_ engine: AgoraRtcEngineKit, audioQualityOfUid uid: UInt, quality: AgoraNetworkQuality, delay: UInt, lost: UInt) {
        print("")
    }
  
   
    func rtcEngine(_ engine: AgoraRtcEngineKit, didApiCallExecute api: String, error: Int) {
        print("")
    }

    
}
