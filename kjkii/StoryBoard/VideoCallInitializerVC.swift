//
//  VideoCallInitializerVC.swift
//  kjkii
//
//  Created by Mazhar on 2021-04-01.
//  Copyright © 2021 abbas. All rights reserved.
//

import UIKit
import AVFoundation

class VideoCallInitializerVC: UIViewController {
    
    @IBOutlet weak var userImgVu: UIImageView!
    var otherUserImage = ""
    var token = ""
    var channel = ""
    var player: AVAudioPlayer?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        playSound(tuneName: "ReceivingTone")
        userImgVu.layer.borderWidth = 1
        userImgVu.layer.masksToBounds = false
        userImgVu.layer.borderColor = UIColor.black.cgColor
        userImgVu.layer.cornerRadius = userImgVu.frame.height/2
        userImgVu.clipsToBounds = true
        UIHelper.shared.setImage(address: otherUserImage, imgView: userImgVu)

        // Do any additional setup after loading the view.
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
    
    
    @IBAction func acceptCallBtnTpd(_ sender: Any) {
        player?.stop()
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let vc = stb.instantiateViewController(withIdentifier: "VideoChatViewController") as! VideoChatViewController
        vc.token = token
        vc.channel = channel
        vc.isvideo = true
        vc.hidesBottomBarWhenPushed = true
       self.present(vc, animated: true, completion: nil)
    }
    
   
}
