//
//  Audio.swift
//  kjkii
//
//  Created by Saeed Rehman on 28/12/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import AVFoundation
func configureAudioSession() {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CALL"), object: nil)
   // AppDelegate.shared?.gotocall()
let session = AVAudioSession.sharedInstance()
do {
    try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.voiceChat, options: [])
    } catch (let error) {
    print("Error while configuring audio session: \(error)")
    }
}
func startAudio() {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CALL"), object: nil)
}
func stopAudio() {
    print("Stopping audio")
}
