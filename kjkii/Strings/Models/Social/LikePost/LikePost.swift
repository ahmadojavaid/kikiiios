//
//  LikePost.swift
//  kjkii
//
//  Created by Shahbaz on 16/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation
struct LikePost {
    var post_id = String()
    func likePost(completion : @escaping(_ done: Bool, _ data: PostLiked?)->Void){
        let url = URL(string: EndPoints.BASE_URL + "likedislike/post/\(post_id)")!
        HttpUtility.shared.getApiData(requestUrl: url, resultType: PostLiked.self) { (result, done) in
            if done{
                guard let result = result else{
                    completion(false, nil)
                    return
                }
                completion(true, result)
            }
            else{
                completion(false, nil)
            }
            
        }
        
        
    }
}




struct PostLiked: Codable {
    let success: Bool
    let message: String
}
