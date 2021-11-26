//
//  VideoCall.swift
//  kjkii
//
//  Created by Saeed Rehman on 24/12/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import AgoraRtcKit
import Firebase
import FirebaseAuth
class VideoCall: UIViewController,AgoraRtcEngineDelegate {
    @IBOutlet weak var otherView: UIView!
    var valueName = "testkiki"
    var agoraKit: AgoraRtcEngineKit!
    var handle: AuthStateDidChangeListenerHandle?
    var localVideo: AgoraRtcVideoCanvas?
    var remoteVideo: AgoraRtcVideoCanvas?
    var localUID = String()
    @IBOutlet weak var localContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAgoraEngine()
        handle = Auth.auth().addStateDidChangeListener {
            (auth, user) in
            self.localUID = user?.uid ?? ""
            print(user?.uid ?? "")
            self.setupLocalVideo(uid: UInt(self.localUID) ?? 0)
        }
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        //CurrentUser.userData()
    }
    
    
    @IBAction func simulateReceivingACall(_ sender: Any) {
        
//        let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
//        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 1.5) {
//            AppDelegate.shared?.displayIncomingCall(uuid: UUID(), handle: self.valueName, hasVideo: true) { error in
//                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
//                if error == nil {
//                    self.setupLocalVideo(uid: UInt(self.localUID) ?? 0)
//                }
//            }
//        }
    }
    @IBAction func btnPressed(_ sender: Any) {
        AppDelegate.shared?.callManager.startCall(handle: valueName, videoEnabled: true)
        self.setupLocalVideo(uid: UInt(self.localUID) ?? 0)
        //        AppDelegate.shared?.callManager.startCall(handle: valueName, videoEnabled: true)
        //
        //
        //        //agoraKit
        //        let backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        //        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 1.5) {
        //            AppDelegate.shared?.displayIncomingCall(uuid: UUID(), handle: self.valueName, completion: { (error) in
        //                UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
        //                if error == nil {
        //                    self.setupLocalVideo(uid: UInt(self.localUID) ?? 0)
        //                     //self.setupLocalVideo(uid: self.localUID)
        //                }
        //
        //            })
        //        }
    }
    func setupLocalVideo(uid:UInt) {
        // This is used to set a local preview.
        // The steps setting local and remote view are very similar.
        // But note that if the local user do not have a uid or do
        // not care what the uid is, he can set his uid as ZERO.
        // Our server will assign one and return the uid via the block
        // callback (joinSuccessBlock) after
        // joining the channel successfully.
        let view = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: localContainer.frame.size))
        localVideo = AgoraRtcVideoCanvas()
        localVideo!.view = view
        localVideo!.renderMode = .hidden
        localVideo!.uid = uid
        localContainer.addSubview(localVideo!.view!)
        agoraKit.setupLocalVideo(localVideo)
        agoraKit.startPreview()
    }
    func initializeAgoraEngine() {
        // init AgoraRtcEngineKit
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "e54a97c363d14e0c94bde391304ec592", delegate: self)
    }
    
}
