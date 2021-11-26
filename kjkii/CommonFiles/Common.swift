//
//  Common.swift
//  kjkii
//
//  Created by Shahbaz on 12/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation
import CoreLocation
import ProgressHUD
import SwiftyJSON
import FirebaseDatabase
import FirebaseStorage
import AVFoundation
struct Common{
    init() {
    }
    static let shared = Common()
    func checkLocation() -> Bool{
        var enabled = Bool()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                enabled =  false
            case .authorizedAlways, .authorizedWhenInUse:
                enabled =  true
            @unknown default:
                enabled =  false
            }
        }
        else {
            print("Location services are not enabled")
            enabled =  false
        }
        return enabled
    }
    
    func attendEvent(id: String, completion: @escaping(_ response: JSON, _ error: Bool)->Void){
        let url = EndPoints.BASE_URL + "attend/event"
        let params = ["id":id]
        ProgressHUD.show()
        postWebCall(url: url, params: params, webCallName: "Attending Event") {(response, error) in
            ProgressHUD.dismiss()
            completion(response, error)
        }
        
    }
    
    
    func updateLocation(lat: String, lng: String, completion: @escaping(_ done: Bool)->Void){
        let url = EndPoints.BASE_URL + "update/profile"
        let params = ["longitude":"\(appDelegate.lng)", "latitude":"\(appDelegate.lat)"]
        postWebCall(url: url, params: params, webCallName: "Updating location") { (response, error) in
            if !error{
                let success = "\(response["success"])"
                if success == "true"{
                    print("updatelocation")
                    let paid = "\(response["user"]["upgraded"])"
                    print(paid)
                    DEFAULTS.setValue(paid, forKey: "isPaid")
                    completion(true)
                }
                else{
                    completion(false)
                }
            }
            else{
                completion(false)
            }
        }
        
    }
    
    func Updatepurchasing(lat: String, lng: String, completion: @escaping(_ done: Bool)->Void){
        let url = EndPoints.BASE_URL + "update/profile"
        let params = ["upgraded":"1"]
        postWebCall(url: url, params: params, webCallName: "Updating location") { (response, error) in
            if !error{
                let success = "\(response["success"])"
                if success == "true"{
                    print("updatelocation")
                    let paid = "\(response["user"]["upgraded"])"
                    print(paid)
                    DEFAULTS.setValue(paid, forKey: "isPaid")
                    completion(true)
                }
                else{
                    completion(false)
                }
            }
            else{
                completion(false)
            }
        }
        
    }
    
    func updateToken(token: String,lastLogin:String, completion: @escaping(_ done: Bool)->Void){
        let url = EndPoints.BASE_URL + "update/profile"
        let params = ["device_token":appDelegate.firebaseToken,"device_type":"ios"]
        postWebCall(url: url, params: params, webCallName: "Updating Token") { (response, error) in
            if !error{
                let success = "\(response["success"])"
                if success == "true"{
                    print(response)
                    completion(true)
                }
                else{
                    completion(false)
                }
            }
            else{
                completion(false)
            }
        }
        
    }
    
    func rewindSwipe(completion: @escaping(_ done: Bool)->Void){
        let url = EndPoints.BASE_URL + "rewind-swipes"
        let params = ["":""]
        postWebCall(url: url, params: params, webCallName: "Rewind Swipe") { (response, error) in
            if !error{
                let success = "\(response["success"])"
                if success == "true"{
                    completion(true)
                }
                else{
                    completion(false)
                }
            }
            else{
                completion(false)
            }
        }
        
    }
    
    func setUserAtFB()
    {
        Database.database().reference().child("Users").child(DEFAULTS.string(forKey: "FBID") ?? "").setValue(["email":"\(CurrentUser.userData()!.email ?? "")","id":"\(CurrentUser.userData()!.id ?? 0)", "image":"\(CurrentUser.userData()!.profile_pic ?? "")", "isOnline":"true", "phoneNumber":"\(CurrentUser.userData()!.phone ?? "")", "type":"user", "userId":"\(DEFAULTS.string(forKey: "FBID")!)", "userName":"\(CurrentUser.userData()!.name ?? "")"])
        
    }
    func getUserFBID(otherUserID: String, completion : @escaping(_ key : String)->Void) {
        let _ = Database.database().reference().child("Users").observe(.value) { (data) in
            for child in data.children
            {
                let msg = child as! DataSnapshot
                let val = msg.value! as! [String:Any]
                let id = "\(val["id"]!)"
                if id == otherUserID{
                    completion(msg.key)
                }
            }
        }
    }
    
    func postMsg(msg: String, ohterFBID: String) {
        let text = msg
        let myString = DEFAULTS.string(forKey: "FBID")! + "___" + ohterFBID
        let otherString =  ohterFBID + "___" + DEFAULTS.string(forKey: "FBID")!
        
        let key =  Database.database().reference().child("Chats").child(otherString).childByAutoId().key
        
        
        let msg = ["deviceType":"iOS",
                   "message":"\(msg)",
                   "messageBy":"\(DEFAULTS.string(forKey: "FBID")!)",
                   "recordingTime":0,
                   "seen":"true",
                   "time":Date().millisecondsSince1970,
                   "type":"text",
                   "messageId":"\(key ?? "")",
                   "userId":"\(DEFAULTS.string(forKey: "FBID")!)"] as [String : Any]
        Database.database().reference().child("Chats").child(otherString).child(key!).setValue(msg)
        Database.database().reference().child("Chats").child(myString).child(key!).setValue(msg)
        let lstMsg = ["deviceType":"iOS",
                      "message":"\(text)",
                      "messageBy":"\(DEFAULTS.string(forKey: "FBID")!)",
                      "recordingTime":0,
                      "seen":"true",
                      "time":Date().millisecondsSince1970,
                      "type":"text",
                      "userId":"\(DEFAULTS.string(forKey: "FBID")!)"] as [String : Any]
        Database.database().reference().child("LastMessages").child(myString).setValue(lstMsg)
        Database.database().reference().child("LastMessages").child(otherString).setValue(lstMsg)
    }
    
    
    func postMsgWithImage(img: UIImage, otherFBID: String){
        
        let ref = Storage.storage().reference().child("chat_imgs").child("\(Date().millisecondsSince1970).jpg")
        if let data = img.jpegData(compressionQuality: 0.2){
            ref.putData(data, metadata: nil) { (meta, erro) in
                ref.downloadURL { (url, error) in
                    if let url = url {
                        let myString = DEFAULTS.string(forKey: "FBID")! + "___" + otherFBID
                        let otherString =  otherFBID + "___" + DEFAULTS.string(forKey: "FBID")!
                        
                        let key =  Database.database().reference().child("Chats").child(otherString).childByAutoId().key
                        
                        
                        let msg = ["deviceType":"iOS",
                                   "message":"\(url.absoluteURL)",
                                   "messageBy":"\(DEFAULTS.string(forKey: "FBID")!)",
                                   "recordingTime":0,
                                   "seen":"true",
                                   "time":Date().millisecondsSince1970,
                                   "type":"image",
                                   "messageId":"\(key ?? "")",
                                   "userId":"\(DEFAULTS.string(forKey: "FBID")!)"] as [String : Any]
                        
                        Database.database().reference().child("Chats").child(otherString).child(key!).setValue(msg)
                        Database.database().reference().child("Chats").child(myString).child(key!).setValue(msg)
                        let lstMsg = ["deviceType":"iOS",
                                      "message":"image",
                                      "messageBy":"\(DEFAULTS.string(forKey: "FBID")!)",
                                      "recordingTime":0,
                                      "seen":"true",
                                      "time":Date().millisecondsSince1970,
                                      "type":"text",
                                      "userId":"\(DEFAULTS.string(forKey: "FBID")!)"] as [String : Any]
                        Database.database().reference().child("LastMessages").child(myString).setValue(lstMsg)
                        Database.database().reference().child("LastMessages").child(otherString).setValue(lstMsg)
                    }
                    
                    
                    
                }
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    func postMsgWithVideo(url: URL, otherFBID: String){
        
        let ref = Storage.storage().reference().child("chat_imgs").child("\(Date().millisecondsSince1970).mov")
        do {
            let data = try Data(contentsOf: url)
            ref.putData(data, metadata: nil) { (meta, erro) in
                ref.downloadURL { (url, error) in
                    if let url = url {
                        let myString = DEFAULTS.string(forKey: "FBID")! + "___" + otherFBID
                        let otherString =  otherFBID + "___" + DEFAULTS.string(forKey: "FBID")!
                        
                        let key =  Database.database().reference().child("Chats").child(otherString).childByAutoId().key
                        
                        
                        let msg = ["deviceType":"iOS",
                                   "message":"\(url.absoluteURL)",
                                   "messageBy":"\(DEFAULTS.string(forKey: "FBID")!)",
                                   "recordingTime":0,
                                   "seen":"true",
                                   "time":Date().millisecondsSince1970,
                                   "type":"video",
                                   "messageId":"\(key ?? "")",
                                   "userId":"\(DEFAULTS.string(forKey: "FBID")!)"] as [String : Any]
                        
                        Database.database().reference().child("Chats").child(otherString).child(key!).setValue(msg)
                        Database.database().reference().child("Chats").child(myString).child(key!).setValue(msg)
                        let lstMsg = ["deviceType":"iOS",
                                      "message":"video",
                                      "messageBy":"\(DEFAULTS.string(forKey: "FBID")!)",
                                      "recordingTime":0,
                                      "seen":"true",
                                      "time":Date().millisecondsSince1970,
                                      "type":"video",
                                      "userId":"\(DEFAULTS.string(forKey: "FBID")!)"] as [String : Any]
                        Database.database().reference().child("LastMessages").child(myString).setValue(lstMsg)
                        Database.database().reference().child("LastMessages").child(otherString).setValue(lstMsg)
                    }
                    
                    
                }
                
            }
        } catch(let error){
            print("error attaching video\(error.localizedDescription)")
           
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    func getOtherUser(id: String, completionHandler: @escaping(_ user: OtherFBUSer?)->Void){
        Database.database().reference().child("Users").observe(.value) { (data) in
            var user : OtherFBUSer?
            for child in data.children
            {
                let msg = child as! DataSnapshot
                let val = msg.value! as! [String:Any]
                if msg.key == id
                {
                    user = OtherFBUSer(email: "\(val["email"]!)",
                                       id: "\(val["id"]!)",
                                       image: "\(val["image"]!)",
                                       isOnline: "\(val["isOnline"]!)",
                                       phoneNumber: "\(val["phoneNumber"]!)",
                                       type: "\(val["type"]!)",
                                       userId: "\(val["userId"]!)",
                                       userName: "\(val["userName"]!)")
                    
                }
                completionHandler(user)
            }
        }
    }
    
    
    func postMsgWithAudio(url: URL, otherFBID: String, recordingTime: String){
        ProgressHUD.show()
        
        let metadata = StorageMetadata()
        metadata.contentType = "audio/mp3"
        DispatchQueue.main.async {
            let ref = Storage.storage().reference().child("\(Date().millisecondsSince1970).m4a")
            ref.putFile(from: url, metadata: nil){
                (metadata, error) in
                
                if error == nil{
                    ref.downloadURL { (url, error) in
                        if let url = url {
                            let myString = DEFAULTS.string(forKey: "FBID")! + "___" + otherFBID
                            let otherString =  otherFBID + "___" + DEFAULTS.string(forKey: "FBID")!
                            let key =  Database.database().reference().child("Chats").child(otherString).childByAutoId().key
                            
                            let msg = ["deviceType":"iOS",
                                       "message":"\(url.absoluteURL)",
                                       "messageBy":"\(DEFAULTS.string(forKey: "FBID")!)",
                                       "recordingTime":Int(recordingTime)!,
                                       "seen":"true",
                                       "time":Date().millisecondsSince1970,
                                       "type":"audio",
                                       "messageId":"\(key ?? "")",
                                       "userId":"\(DEFAULTS.string(forKey: "FBID")!)"] as [String : Any]
                            
                            Database.database().reference().child("Chats").child(otherString).child(key!).setValue(msg)
                            Database.database().reference().child("Chats").child(myString).child(key!).setValue(msg)
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
                            ProgressHUD.dismiss()
                        }
                    }
                }
                
            }
        }
        
        
        
        //        do {
        //
        //
        //            ref.putFile(from: url.absoluteURL, metadata: metadata) { (meta, erro) in
        //
        //                print(erro?.localizedDescription)
        //
        //                ref.downloadURL { (url, error) in
        ////                    if let url = url {
        ////                    let myString = DEFAULTS.string(forKey: "FBID")! + "___" + otherFBID
        ////                    let otherString =  otherFBID + "___" + DEFAULTS.string(forKey: "FBID")!
        ////
        ////                    let key =  Database.database().reference().child("Chats").child(otherString).childByAutoId().key
        ////
        ////
        ////                    let msg = ["deviceType":"iOS",
        ////                               "message":"\(url.absoluteURL)",
        ////                               "messageBy":"\(DEFAULTS.string(forKey: "FBID")!)",
        ////                               "recordingTime":Int(recordingTime)!,
        ////                               "seen":"true",
        ////                               "time":Date().millisecondsSince1970,
        ////                               "type":"audio",
        ////                               "messageId":"\(key ?? "")",
        ////                               "userId":"\(DEFAULTS.string(forKey: "FBID")!)"] as [String : Any]
        ////
        ////                    Database.database().reference().child("Chats").child(otherString).child(key!).setValue(msg)
        ////                    Database.database().reference().child("Chats").child(myString).child(key!).setValue(msg)
        ////                    let lstMsg = ["deviceType":"iOS",
        ////                                  "message":"audio",
        ////                                  "messageBy":"\(DEFAULTS.string(forKey: "FBID")!)",
        ////                                  "recordingTime":0,
        ////                                  "seen":"true",
        ////                                  "time":Date().millisecondsSince1970,
        ////                                  "type":"audio",
        ////                                  "userId":"\(DEFAULTS.string(forKey: "FBID")!)"] as [String : Any]
        ////                    Database.database().reference().child("LastMessages").child(myString).setValue(lstMsg)
        ////                    Database.database().reference().child("LastMessages").child(otherString).setValue(lstMsg)
        ////                        ProgressHUD.dismiss()
        ////                    }
        //
        //
        //        }
        //
        //    }
        //        } catch(let error){
        //            ProgressHUD.dismiss()
        //            print("error attaching audio\(error.localizedDescription)")
        //        }
    }
    
    
}



func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
    print("I am called... ")
    DispatchQueue.global().async { //1
        let asset = AVAsset(url: url) //2
        let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
        avAssetImageGenerator.appliesPreferredTrackTransform = true //4
        let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
        do {
            let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
            let thumbImage = UIImage(cgImage: cgThumbImage) //7
            DispatchQueue.main.async { //8
                completion(thumbImage) //9
            }
        } catch {
            print(error.localizedDescription) //10
            DispatchQueue.main.async {
                completion(nil) //11
            }
        }
    }
    
    
    
}
