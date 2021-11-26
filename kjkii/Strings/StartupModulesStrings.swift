//
//  File.swift
//  kjkii
//
//  Created by abbas on 7/26/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
class OnBoardingStrings: NSObject {
    // ImageName, Title, Detail Text
    static let pages:[[String]] = [
        [ "onboarding_1","Find", "Find your perfect romantic relationship or friendship.", "Find Real People - Every Profile is verified."
        ], [
            "onboarding_2","Match", "Once matched you have 24 hours to start a conversation.", "Send voice notes and pictures to your match."
        ], [
            "onboarding_3","Chat", "Virtually date anyone from anywhere around the UK & Ireland.", "Connect and chat via voice call\n(No personal phone numbers given out)"
        ], [
            "onboarding_4","News Feed", "Keep up with the Kikii Community via the Social and Events feed.", "If you’re offered a seat on a rocket ship, don’t ask what seat! Just get on."
        ]
    ]
}
struct AgoraPoints {
    static let AppID     = "3e9f393f860e4cbbb2a1b76b96505ac7"
    static let Token     = "0063e9f393f860e4cbbb2a1b76b96505ac7IAAbAW0cdqjyqJpo4D0iiWoBKXDcUwMcIx7CmR34oPPmMLdIfRAAAAAAIgBZ0AAA4ub+XwQAAQByo/1fAwByo/1fAgByo/1fBAByo/1f"
}
struct EndPoints {
    static let BASE_URL     = "https://kikii.uk/api/"
    static let waitString   = "Please Wait..."
    static var FireBaseUser = String()
}


extension UIViewController {
    func alert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
