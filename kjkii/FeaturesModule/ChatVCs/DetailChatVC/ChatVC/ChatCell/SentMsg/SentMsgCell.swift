//
//  SentMsgCell.swift
//  kjkii
//
//  Created by Shahbaz on 05/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVKit


class SentMsgCell: UITableViewCell {
    
    @IBOutlet weak var playAudioImage: UIImageView!
    @IBOutlet var textMsgContraints: [NSLayoutConstraint]!
    @IBOutlet weak var auidoView    : UIView!
    @IBOutlet weak var audiomsgHeight: NSLayoutConstraint!
    @IBOutlet var heightsToZero     : [NSLayoutConstraint]!
    @IBOutlet var lblsToClear       : [APLabel]!
    @IBOutlet var viewToHide        : [UIView]!
    
    @IBOutlet weak var userImage    : UIImageView!
    @IBOutlet weak var msgImg       : UIImageView!
    @IBOutlet weak var userName     : APLabel!
    @IBOutlet weak var msgBody      : APLabel!
    @IBOutlet weak var timeLabel    : APLabel!
    @IBOutlet weak var imgHeight    : NSLayoutConstraint!
    @IBOutlet weak var cellBackView : UIView!
    @IBOutlet weak var labelOverallDuration: UILabel!
    @IBOutlet weak var labelCurrentTime: UILabel!
    @IBOutlet weak var playbackSlider: UISlider!
    @IBOutlet weak var ButtonPlay: UIButton!
    fileprivate let seekDuration: Float64 = 10
    var row                         = Int()
    var delegate                    : SelectedMsgDelegage?
    var audioMsgUrl                 : String?
    var isPlayingAudio              = false
    var player                      : AVPlayer?
    var progressTimer:Timer?
    {
        willSet {
            progressTimer?.invalidate()
        }
    }
    var playerItem: AVPlayerItem?
    var playerStream: AVPlayer?
    
    

    
    func configCell(item: FireBaseMessage, row: Int){
        UIHelper.shared.setImage(address: CurrentUser.userData()!.profile_pic ?? "", imgView: userImage)
        
        self.row = row
        let long = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        self.addGestureRecognizer(long)
        
        
        if item.type == "text"{
            textMsgContraints.forEach({$0.priority = UILayoutPriority(rawValue: 1000)})
            auidoView.isHidden = true
            imgHeight.priority  = UILayoutPriority(rawValue: 200)
            audiomsgHeight.priority = UILayoutPriority(rawValue: 200)
            msgBody.text        = item.message
            msgImg.image        = nil
            imgHeight.constant  = 0.0
            msgImg.isHidden     = true
            msgBody.isHidden    = false
        }
        else if item.type == "video"
        {
            textMsgContraints.forEach({$0.priority = UILayoutPriority(rawValue: 200)})
            auidoView.isHidden = true
            imgHeight.priority  = UILayoutPriority(rawValue: 1000)
            msgBody.isHidden    = true
            msgBody.text        = nil
            getThumbnailImageFromVideoUrl(url: URL(string: item.message)!) { [weak self](img) in
                guard let self = self else {return}
                self.msgImg.image = img
            }
            imgHeight.constant  = 200
            audiomsgHeight.priority = UILayoutPriority(rawValue: 200)
            msgImg.isHidden     = false
        }
        else if item.type == "image"
        {
            textMsgContraints.forEach({$0.priority = UILayoutPriority(rawValue: 200)})
            auidoView.isHidden = true
            imgHeight.priority  = UILayoutPriority(rawValue: 1000)
            msgBody.isHidden    = true
            msgBody.text        = nil
            UIHelper.shared.setImage(address: item.message, imgView: msgImg)
            imgHeight.constant  = 200
            audiomsgHeight.priority = UILayoutPriority(rawValue: 200)
            msgImg.isHidden     = false
        } else if item.type == "audio"{
            textMsgContraints.forEach({$0.priority = UILayoutPriority(rawValue: 200)})
            auidoView.isHidden = false
            audioMsgUrl = item.message
            let time = (Double(item.recordingTime) ?? 0.0) / 1000
            labelOverallDuration.text = stringFromTimeInterval(interval: time)
          
            audiomsgHeight.priority = UILayoutPriority(rawValue: 1000)
        }
        
        userName.text       = CurrentUser.userData()!.name
        let time            = Date(milliseconds: Int64(Double(item.time) ?? 0.0))
        timeLabel.text      = timeIntervalWithDate(dateWithTime: time)
        UIHelper.shared.setCell(cell: self)
        if item.isSelected{
            cellBackView.backgroundColor = UIColor(named: "selectedMsg")
        } else{
            cellBackView.backgroundColor = .clear
        }
        
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer){
        if sender.state == .began{
            delegate?.selectedMsgs(row: row)
        }
    }
    
    @IBAction func playAudioBtnPressed(_ sender: Any) {
        if let _ = audioMsgUrl{
            if !isPlayingAudio{
                initAudioPlayer()
                player!.play()
                playAudioImage.image = UIImage(named: "pauseicon")
            }
            else{
                player?.pause()
                playAudioImage.image = UIImage(named: "playAudioImg")
            }
            isPlayingAudio = !isPlayingAudio
        }
    }
    
    
    
    func initAudioPlayer(){
        let url = URL(string: audioMsgUrl ?? "")
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        
        playbackSlider.minimumValue = 0
        
        //To get overAll duration of the audio
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        labelOverallDuration.text = self.stringFromTimeInterval(interval: seconds)
       
        //To get the current duration of the audio
        let currentDuration : CMTime = playerItem.currentTime()
        let currentSeconds : Float64 = CMTimeGetSeconds(currentDuration)
        labelCurrentTime.text = self.stringFromTimeInterval(interval: currentSeconds)
        
        
        playbackSlider.maximumValue = Float(seconds)
        playbackSlider.isContinuous = true
        
        
        
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                self.playbackSlider.value = Float ( time );
                self.labelCurrentTime.text = self.stringFromTimeInterval(interval: time)
               
            }
            let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
            if playbackLikelyToKeepUp == false{
                print("IsBuffering")
                self.ButtonPlay.isHidden = true
                //        self.loadingView.isHidden = false
            } else {
                //stop the activity indicator
                print("Buffering completed")
                self.ButtonPlay.isHidden = false
                //        self.loadingView.isHidden = true
            }
        }
       
       //change the progress value
        playbackSlider.addTarget(self, action: #selector(playbackSliderValueChanged(_:)), for: .valueChanged)
        
        //check player has completed playing audio
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)}


    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider) {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        player!.seek(to: targetTime)
        if player!.rate == 0 {
            player?.play()
        }
    }

    @objc func finishedPlaying( _ myNotification:NSNotification) {
        ButtonPlay.setImage(UIImage(named: "play"), for: UIControl.State.normal)
        playAudioImage.image = UIImage(named: "playAudioImg")
        //reset player when finish
        playbackSlider.value = 0
        let targetTime:CMTime = CMTimeMake(value: 0, timescale: 1)
        player!.seek(to: targetTime)
    }

    @IBAction func playButton(_ sender: Any) {
        print("play Button")
//        if player?.rate == 0
//        {
//            if !isPlayingAudio{
//                player!.play()
//                self.ButtonPlay.isHidden = true
//            }
//            else{
//                player!.pause()
//                self.ButtonPlay.isHidden = false
//            }
//
//            //        self.loadingView.isHidden = false
//            //ButtonPlay.setImage(UIImage(systemName: "pause"), for: UIControl.State.normal)
//        } else {
//            player!.pause()
//            //ButtonPlay.setImage(UIImage(systemName: "play"), for: UIControl.State.normal)
//        }
        
    }


    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }



    @IBAction func seekBackWards(_ sender: Any) {
        if player == nil { return }
        let playerCurrenTime = CMTimeGetSeconds(player!.currentTime())
        var newTime = playerCurrenTime - seekDuration
        if newTime < 0 { newTime = 0 }
        player?.pause()
        let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        player?.seek(to: selectedTime)
        player?.play()

    }


    @IBAction func seekForward(_ sender: Any) {
        if player == nil { return }
        if let duration = player!.currentItem?.duration {
           let playerCurrentTime = CMTimeGetSeconds(player!.currentTime())
           let newTime = playerCurrentTime + seekDuration
           if newTime < CMTimeGetSeconds(duration)
           {
              let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as
           Float64), timescale: 1000)
              player!.seek(to: selectedTime)
           }
           player?.pause()
           player?.play()
          }
    }
    
    
    
    
}
