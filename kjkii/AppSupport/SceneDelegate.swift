//
//  SceneDelegate.swift
//  kjkii
//
//  Created by abbas on 7/25/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
import Firebase
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("come into scene")
        
        if let _ = CurrentUser.userData()?.id{
            guard let windoScence = (scene as? UIWindowScene) else { return }
            window = UIWindow(frame: windoScence.coordinateSpace.bounds)
            window?.windowScene = windoScence
            window?.rootViewController = createTabBar()
            window?.makeKeyAndVisible()
            
            
            
        }
        
    }
    
//   func scene(_ scene: UIScene, continue userActivity: NSUserActivity,restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    
    print("in hoa hy")
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
    }
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
        if components.path == "/store"{
            if let postIDQueryItem = queryItems.first(where: {$0.name == "post_id"}){
                guard let postID = postIDQueryItem.value else{return}
                print("get your window here")
                movetoController(postid: postID)
            }
            if let postIDQueryItem1 = queryItems.first(where: {$0.name == "profile_id"}){
                guard let postID = postIDQueryItem1.value else{return}
                print("get your window here")
                movetoControllerB(postid: postID)
            }
            if let postIDQueryItem1 = queryItems.first(where: {$0.name == "event_id"}){
                guard let postID = postIDQueryItem1.value else{return}
                print("get your window here")
                movetoControllerEvent(postid: postID)
            }
        }
    }
  
    func movetoController(postid: String){
        
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommunityDetailVC") as? CommunityDetailVC {
//            controller.postid = postIdHere
//            controller.fromPush = false
//            controller.isMyPost = true
            controller.comefromDeepLink = true
            controller.singlePostID = postid
            if let window = self.window, let rootViewController = window.rootViewController {
                var currentController = rootViewController
                while let presentedController = currentController.presentedViewController {
                    currentController = presentedController
                }
                currentController.present(controller, animated: true, completion: nil)
            }
        }
        
    }
    func movetoControllerB(postid: String){
       
         let controller = ProfileVC(nibName: "ProfileVC", bundle: nil)
            controller.isOtherProfile = true
            controller.id = postid
            if let window = self.window, let rootViewController = window.rootViewController {
                var currentController = rootViewController
                while let presentedController = currentController.presentedViewController {
                    currentController = presentedController
                }
                currentController.present(controller, animated: true, completion: nil)
            }
        
        
    }
    func movetoControllerEvent(postid: String){
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventDetailVC") as? EventDetailVC {
//         let controller = EventDetailVC(nibName: "EventDetailVC", bundle: nil)
            controller.comeFromLink = true
            controller.EventID = postid
            if let window = self.window, let rootViewController = window.rootViewController {
                var currentController = rootViewController
                while let presentedController = currentController.presentedViewController {
                    currentController = presentedController
                }
                currentController.present(controller, animated: true, completion: nil)
            }
        }
        
        
    }
    func movetoMatchController(profileLink: String, userID: String){
//        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MatchProfileVC") as? MatchProfileVC {
//            controller.profileImage1 = profileLink
//            controller.selectedMatchId = userID
//            if let window = self.window, let rootViewController = window.rootViewController {
//                var currentController = rootViewController
//                while let presentedController = currentController.presentedViewController {
//                    currentController = presentedController
//                }
//                currentController.present(controller, animated: true, completion: nil)
//            }
//        }
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier :"MatchProfileVC") as! MatchProfileVC
//        let navController = UINavigationController.init(rootViewController: viewController)
//
//           if let window = self.window, let rootViewController = window.rootViewController {
//               var currentController = rootViewController
//               while let presentedController = currentController.presentedViewController {
//                   currentController = presentedController
//                }
//                   currentController.present(navController, animated: true, completion: nil)
//           }
        
        
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewControlleripad = mainStoryboard.instantiateViewController(withIdentifier: "MatchProfileVC") as! MatchProfileVC
        initialViewControlleripad.selectedMatchId = userID
        initialViewControlleripad.profileImage1 = profileLink
                if let navigationController = self.window?.rootViewController as? UINavigationController
                {
                    
                    navigationController.pushViewController(initialViewControlleripad, animated: true)
                }
                else
                {
                    print("Navigation Controller not Found")
                }
        
        
    }
   
    func movetoCallController(isAudio: Bool, token: String, channel: String, userName: String, userProfileImage: String){
        if isAudio{
            if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VoiceChatViewController") as? VoiceChatViewController {
                controller.token = token
                controller.channel = channel
                controller.comeFromNotification = true
               
                controller.otherUserNameNoti = userName
                controller.otherUserImageNoti = userProfileImage
                 controller.hidesBottomBarWhenPushed = true
                 if let window = self.window, let rootViewController = window.rootViewController {
                     var currentController = rootViewController
                     while let presentedController = currentController.presentedViewController {
                         currentController = presentedController
                     }
                     currentController.present(controller, animated: true, completion: nil)
                 }
             }
            
        }else{
           if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoCallInitializerVC") as? VideoCallInitializerVC {
            controller.token = token
            controller.channel = channel
            controller.otherUserImage = userProfileImage
                if let window = self.window, let rootViewController = window.rootViewController {
                    var currentController = rootViewController
                    while let presentedController = currentController.presentedViewController {
                        currentController = presentedController
                    }
                    currentController.present(controller, animated: true, completion: nil)
                }
            }
        }
       
    }

//    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink){
//        
//        guard let url = dynamicLink.url else{
//            print("no url")
//            return
//        }
//        print("your incoming link parameter is \(url.absoluteString)")
//    }
//    
//    
//    
//    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
//        print("scene men ajaiey")
//        if let  incommingURL = userActivity.webpageURL{
//            print ("Incomming URL is \(DynamicLinks.dynamicLinks())")
//            
//            let linkHandeled = DynamicLinks.dynamicLinks().handleUniversalLink(incommingURL) { (dynamicLink, error) in
//                guard error == nil else{
//                    print("Found an error \(error!.localizedDescription)")
//                    return
//                }
//        }
//        }
//    }

    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func createTabBar() -> UIViewController{
        let stb = UIStoryboard(name: "Main", bundle: nil)
        
       
        return stb.instantiateViewController(withIdentifier: "MainTabBarController") as! UINavigationController

//        return stb.instantiateViewController(withIdentifier: "MatchProfileVC")
        
    }


}

