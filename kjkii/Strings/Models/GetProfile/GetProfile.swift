//
//  GetProfile.swift
//  kjkii
//
//  Created by Shahbaz on 28/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation
import ProgressHUD
struct GetProfile {
    var id = String()
    func getProfile(completion : @escaping(Result<GetProfileResponse, ErrorMessage>)->Void){
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorHUD = UIColor(named: "appRed")!
        ProgressHUD.show()
        if let url = URL(string: EndPoints.BASE_URL + "profile?user_id=\(id)") {
            print(url.absoluteString)
            HttpUtility.shared.getApiData(requestUrl: url, resultType: GetProfileResponse.self) { (result, done) in
                ProgressHUD.dismiss()
                if done{
                    guard let result = result else{
                        completion(.failure(.invalidResponse))
                        return
                    }
                    completion(.success(result))
                }
                else{
                    completion(.failure(.invalidResponse))
                }
                
            }
        }
        
    }
}
