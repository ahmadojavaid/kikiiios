//
//  AgoraCalling.swift
//  kjkii
//
//  Created by Saeed Rehman on 30/12/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import AgoraRtcKit
class AgoraCalling: UIViewController {

    @IBOutlet weak var remoteView: UIView!
    // Defines localView
        var localView: UIView!
        // Defines remoteView
    var agoraKit: AgoraRtcEngineKit?
         override func viewDidLoad() {
            super.viewDidLoad()
            // This function initializes the local and remote video views
            initView()
            // The following functions are used when calling Agora APIs
            initializeAgoraEngine()
            setupLocalVideo()
            joinChannel()
         }
    @IBAction func cancelBtnPressed(_ sender: Any) {
        leaveChannel()
        self.navigationController?.popViewController(animated: true)
    }
    // Sets the video view layout
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            remoteView.frame = self.view.bounds
            localView.frame = CGRect(x: self.view.bounds.width - 90, y: 0, width: 90, height: 160)
        }
        func initView() {
            // Initializes the remote video view
//            remoteView = UIView()
//            self.view.addSubview(remoteView)
            // Initializes the local video view
            localView = UIView()
            self.view.addSubview(localView)
        }
    func initializeAgoraEngine() {
           agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "8ee1391211f54a80b334a55274e35c63", delegate: self)
        }
    func setupLocalVideo() {
        // Enables the video module
        agoraKit?.enableVideo()
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .hidden
        videoCanvas.view = localView
        // Sets the local video view
        agoraKit?.setupLocalVideo(videoCanvas)
        }
    func joinChannel(){
            agoraKit?.joinChannel(byToken: "0068ee1391211f54a80b334a55274e35c63IAAj4GBilhIR40H7rctXv4815w83aVTGzTml8tECsHQ2XY3OU7gAAAAAEACpE93IuZ/5XwEAAQC5n/lf", channelId: "my", info: nil, uid: 0, joinSuccess: { (channel, elapsed, uid) in
        })
    }
    func leaveChannel() {
        
            agoraKit?.leaveChannel(nil)
        }
}
extension AgoraCalling: AgoraRtcEngineDelegate {
    // Monitors the firstRemoteVideoDecodedOfUid callback
    // The SDK triggers the callback when it has received and decoded the first video frame from the remote user
    func rtcEngine(_ engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        // Sets the remote video view
        agoraKit?.setupRemoteVideo(videoCanvas)
    }
}
