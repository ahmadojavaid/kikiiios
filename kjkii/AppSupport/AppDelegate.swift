//
//  AppDelegate.swift
//  kjkii
//
//  Created by abbas on 7/25/20.
//  Copyright © 2020 abbas. All rights reserved.
//
@available(iOS 13.0, *)
let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate

import UIKit
import IQKeyboardManagerSwift
import CoreLocation
import Firebase
import FirebaseMessaging
import FirebaseAuth
import FirebaseDynamicLinks
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate,MessagingDelegate,UNUserNotificationCenterDelegate {
    let gcmMessageIDKey     = "gcm.Message.ID"
    var providerDelegate    : ProviderDelegate!
    let callManager         = CallManager()
    var manager             = CLLocationManager()
    var lat                 = Double()
    var lng                 = Double()
    var isNotificationReceived = Bool()
    var firebaseToken = String()
    var window: UIWindow?
    var valueName = "testkiki"
    var CallToken = String()
    var CallChannel = String()
    var CallType = String()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        print("aya hy")
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
       
        Messaging.messaging().delegate = self
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = Theme.Colors.tint
        providerDelegate = ProviderDelegate(callManager: callManager)
        
        if let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
            if let aps1 = userInfo as? NSDictionary {
                print("data")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CALL"), object: nil)
                print(aps1)
            }
        }
        
        if CLLocationManager.locationServicesEnabled()
        {
            manager = CLLocationManager()
            manager.delegate            = self
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
            manager.distanceFilter      = 2000
            manager.desiredAccuracy     = kCLLocationAccuracyBest
            manager.startMonitoringSignificantLocationChanges()
            if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
            {
                lat = manager.location?.coordinate.latitude ?? 0.0
                lng = manager.location?.coordinate.longitude ?? 0.0
                print(manager.location)
            }
            
            
        }
        else
        {
            manager.startUpdatingLocation()
            print("Location DIsables...")
            
        }
        
        if launchOptions != nil{
            let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification]
            if userInfo != nil {
                self.perform(#selector(self.dil), with: nil, afterDelay: 3.0)
            }
        }
        
        return true
    }
    
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return application(app, open: url,
                         sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                         annotation: "")
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
        print(dynamicLink)
        print("function getttting called")
        // Handle the deep link. For example, show the deep-linked content or
        // apply a promotional offer to the user's account.
        // ...
        return true
      }
      return false
    }
    
    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink){
        print("function getttting called")
        guard let url = dynamicLink.url else{
            print("no url")
            return
        }
        print("your incoming link parameter is \(url.absoluteString)")
        guard(dynamicLink.matchType == .unique || dynamicLink.matchType == .default) else{
            print("Not a strong enough match type to continue")
            return
        }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else{return}
        if components.path == "/posts"{
            if let postIDQueryItem = queryItems.first(where: {$0.name == "posts_ID"}){
                guard let postID = postIDQueryItem.value else{return}
                print("get your window here")
            }
        }
    }


    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool{
        print("DynamicLinks")
        print("function getttting called")
        if let  incommingURL = userActivity.webpageURL{
            print ("Incomming URL is \(DynamicLinks.dynamicLinks())")

            let linkHandeled = DynamicLinks.dynamicLinks().handleUniversalLink(incommingURL) { (dynamicLink, error) in
                guard error == nil else{
                    print("Found an error \(error!.localizedDescription)")
                    return
                }
                if let dynamicLink = dynamicLink{
                    self.handleIncomingDynamicLink(dynamicLink)
                }
            }
            if linkHandeled {
                return true
            }else{
                return false
            }
        }
        return false
    }
    
    
    
    @objc func dil(){
        let callData:[String:String] = ["Token": CallToken,"Channel" : CallChannel,"Type": CallType]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CALL"), object: nil,userInfo: callData)
    }
    // MARK: UISceneSession Lifeecycle
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    ////        self.lat = locations[0].coordinate.latitude
    ////        self.lng = locations[0].coordinate.longitude
    ////        if let _ = CurrentUser.userData()?.id{
    ////            Common.shared.updateLocation(lat: "\(self.lat)", lng: "\(lng)") { (done) in
    ////            }
    ////        }
    //
    //
    //    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func displayIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false, completion: ((NSError?) -> Void)?) {
        print("call")
        
        AppDelegate.shared?.providerDelegate.reportIncomingCall(uuid: uuid, handle: handle, hasVideo: hasVideo, completion: completion)
    }
    func gotocall(){
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let vc = stb.instantiateViewController(withIdentifier: "VoiceChatViewController") as! VoiceChatViewController
        vc.hidesBottomBarWhenPushed     = true
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        if let token = userInfo["token"] as? String {
            CallToken = token
            print("mytoken")
            print(token)
        }
        if let channel = userInfo["channel_name"] as? String {
            print("channle")
            CallChannel = channel
            print(channel)
        }
        
        if let type = userInfo["type"] as? String {
            print("type")
            CallType = type
            print(type)
        }
        print("*************************")
        print(CallType)
        let callData:[String:String] = ["Token": CallToken,"Channel" : CallChannel,"Type": CallType]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CALL"), object: nil,userInfo: callData)
        
        
        // Print full message.
        
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        //print("Firebase registration token: \(String(describing: fcmToken))")
        firebaseToken = fcmToken!
        print("hoa keh nai????")
        print(firebaseToken)
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        print("diccc")
        print(dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        firebaseToken = Messaging.messaging().fcmToken ?? ""
//    }
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        
        if let token = userInfo["token"] as? String {
            CallToken = token
            print("mytoken")
            print(token)
            DEFAULTS.setValue(token, forKey: "agoratoken")
        }
        if let channel = userInfo["channel_name"] as? String {
            print("channle")
            CallChannel = channel
            print(channel)
            DEFAULTS.setValue(channel, forKey: "agorachannel")
        }
        
        if let type = userInfo["type"] as? String {
            print("type")
            if type == "match"{
                let userID = userInfo["id"] as? String
                let picUrl = userInfo["profile_pic"] as? String
//                resetRoot()
                movetoController(imageLink: picUrl!, userID: userID!)
                
            }else if type == "audio"{
                let userName = userInfo["sender_name"] as? String ?? ""
                let userImage = userInfo["sender_image"] as? String ?? ""
                movetoCallController(isAudio: true, token: CallToken, channel: CallChannel, userName: userName, userImage: userImage)
            } else if type == "video"{
                let userName = userInfo["sender_name"] as? String ?? ""
                let userImage = userInfo["sender_image"] as? String ?? ""
                movetoCallController(isAudio: false, token: CallToken, channel: CallChannel, userName: userName, userImage: userImage)
            }  else if type == "missed_call"{
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "missedCall"), object: nil,userInfo: nil)
             
            }
            CallType = type
            print(type)
            DEFAULTS.setValue(type, forKey: "type")
                let callData:[String:String] = ["Token": CallToken,"Channel" : CallChannel,"Type": CallType]
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CALL"), object: nil,userInfo: callData)
                
            
        }
        
//        let callData:[String:String] = ["Token": CallToken,"Channel" : CallChannel,"Type": CallType]
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CALL"), object: nil,userInfo: callData)
//
        // Change this to your preferred presentation option
        
        completionHandler([[.alert, .sound, .badge]])
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  didReceive response: UNNotificationResponse,
                                  withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        if let token = userInfo["token"] as? String {
            CallToken = token
            print("mytoken")
            print(token)
            DEFAULTS.setValue(token, forKey: "agoratoken")
        }
        if let channel = userInfo["channel_name"] as? String {
            print("channle")
            CallChannel = channel
            print(channel)
            DEFAULTS.setValue(channel, forKey: "agorachannel")
        }
        
        if let type = userInfo["type"] as? String {
            print("type")
            if type == "match"{
                let userID = userInfo["id"] as? String
                let picUrl = userInfo["profile_pic"] as? String
                movetoController(imageLink: picUrl!, userID: userID ?? "")
                
            }else{
            CallType = type
            print(type)
            DEFAULTS.setValue(type, forKey: "type")
            }
        }
        if let type = userInfo["type"] as? String {
            print("type")
            if type == "post_like" || type == "post_comment" || type == "comment_reply" {
                let postID = userInfo["post_id"] as? String
               
                movetoPostController(postID: postID!)
                
            }
            else if type == "audio"{
               let userName = userInfo["sender_name"] as? String ?? ""
               let userImage = userInfo["sender_image"] as? String ?? ""
               movetoCallController(isAudio: true, token: CallToken, channel: CallChannel, userName: userName, userImage: userImage)
           } else if type == "video"{
               let userName = userInfo["sender_name"] as? String ?? ""
               let userImage = userInfo["sender_image"] as? String ?? ""
               movetoCallController(isAudio: false, token: CallToken, channel: CallChannel, userName: userName, userImage: userImage)
           } else if type == "missed_call"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "missedCall"), object: nil,userInfo: nil)
        }
            else{
            CallType = type
            print(type)
            DEFAULTS.setValue(type, forKey: "type")
            }
             
        }
        
        
//        let callData:[String:String] = ["Token": CallToken,"Channel" : CallChannel,"Type": CallType]
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CALL"), object: nil,userInfo: callData)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        print("full info")
        print(userInfo)
        
        completionHandler()
    }
    func createTabBar() -> UIViewController{
        let stb = UIStoryboard(name: "Main", bundle: nil)
        return stb.instantiateViewController(withIdentifier: "MainTabBarController") as! UINavigationController
//        return stb.instantiateViewController(withIdentifier: "MatchProfileVC")
    }
    
    func movetoController(imageLink: String, userID: String){
//
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
               let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MatchProfileVC") as! MatchProfileVC
           if #available(iOS 13.0, *){

            sceneDelegate.movetoMatchController(profileLink: imageLink, userID: userID)
               
           } else {
               appDelegate.window?.rootViewController = vc
               appDelegate.window?.makeKeyAndVisible()
           }
        
        
        
       
        }
    func movetoCallController(isAudio: Bool,token: String, channel: String, userName: String, userImage:String){
//
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
               let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MatchProfileVC") as! MatchProfileVC
           if #available(iOS 13.0, *){

            sceneDelegate.movetoCallController(isAudio: isAudio, token: token, channel: channel, userName: userName, userProfileImage: userImage)
               
           } else {
               appDelegate.window?.rootViewController = vc
               appDelegate.window?.makeKeyAndVisible()
           }
        
        
        
       
        }
    func movetoPostController(postID: String){
//
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
               let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommunityDetailVC") as! CommunityDetailVC
           if #available(iOS 13.0, *){

            sceneDelegate.movetoController(postid: postID)
               
           } else {
               appDelegate.window?.rootViewController = vc
               appDelegate.window?.makeKeyAndVisible()
           }
        
        
        
       
        }
    func resetRoot() {
                guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MatchProfileVC") as? MatchProfileVC else {
                    return
                }
                let navigationController = UINavigationController(rootViewController: rootVC)

                UIApplication.shared.windows.first?.rootViewController = rootVC
                UIApplication.shared.windows.first?.makeKeyAndVisible()
         }
        
    
}

func manageScreens(){
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Session"), object: nil)
}

