//
//  KikiPosts.swift
//  kjkii
//
//  Created by Shahbaz on 20/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation
struct GetKikiPosts {
    init() {}
    static let shared = GetKikiPosts()
    func getPosts(completion: @escaping(Result<KikiPosts, ErrorMessage>)->Void){
        let url = URL(string: EndPoints.BASE_URL + "posts")
        HttpUtility.shared.getApiData(requestUrl: url!, resultType: KikiPosts.self) { (result, done) in
            if done{
                guard let result = result else{
                    completion(.failure(.inValidUserName))
                    return
                }
                completion(.success(result))
            }
            else{
                completion(.failure(.inValidUserName))
            }
            
        }
        
    }
}





struct KikiPosts: Codable {
    let success : Bool?
    let message : String?
    let next_offset : Int?
    let posts : [KiPosts]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case next_offset = "next_offset"
        case posts = "Posts"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        next_offset = try values.decodeIfPresent(Int.self, forKey: .next_offset)
        posts = try values.decodeIfPresent([KiPosts].self, forKey: .posts)
    }

}
struct KiPosts : Codable {
    let id : Int?
    let body : String?
    let user_id : String?
    let created_at : String?
    let updated_at : String?
    let likes_count : Int?
    let comments_count : Int?
    let isLiked : Int?
    let user :CommunityUser?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case body = "body"
        case user_id = "user_id"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case likes_count = "likes_count"
        case comments_count = "comments_count"
        case isLiked = "IsLiked"
        case user = "user"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        body = try values.decodeIfPresent(String.self, forKey: .body)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        likes_count = try values.decodeIfPresent(Int.self, forKey: .likes_count)
        comments_count = try values.decodeIfPresent(Int.self, forKey: .comments_count)
        isLiked = try values.decodeIfPresent(Int.self, forKey: .isLiked)
        user = try values.decodeIfPresent(CommunityUser.self, forKey: .user)
    }

}
