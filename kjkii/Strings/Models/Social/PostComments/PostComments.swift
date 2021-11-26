//
//  PostComments.swift
//  kjkii
//
//  Created by Shahbaz on 16/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation
struct PostComments {
    var post_id = String()
    func getComments(completion: @escaping(Result<PostCommentsResponse, ErrorMessage>)->Void){
        let url = URL(string: EndPoints.BASE_URL + "post/comments?post_id=\(post_id)")!
        HttpUtility.shared.getApiData(requestUrl: url, resultType: PostCommentsResponse.self) { (result, done) in
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



struct PostCommentsResponse :  Codable {
    let success         : Bool?
    let message         : String?
    let next_offset     : Int?
    let comments        : [Comments]?

    enum CodingKeys: String, CodingKey {

        case success = "success"
        case message = "message"
        case next_offset = "next_offset"
        case comments = "comments"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        next_offset = try values.decodeIfPresent(Int.self, forKey: .next_offset)
        comments = try values.decodeIfPresent([Comments].self, forKey: .comments)
    }

}

struct Comments : Codable {
    let id : Int?
    let body : String?
    let post_id : Int?
    let user_id : Int?
    let created_at : String?
    let updated_at : String?
    let comment_id : String?
    let reply_id : String?
    let user : CommunityUser?
    let replies : [Replies]?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case body = "body"
        case post_id = "post_id"
        case user_id = "user_id"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case comment_id = "comment_id"
        case reply_id = "reply_id"
        case user = "user"
        case replies = "replies"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        body = try values.decodeIfPresent(String.self, forKey: .body)
        post_id = try values.decodeIfPresent(Int.self, forKey: .post_id)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        comment_id = try values.decodeIfPresent(String.self, forKey: .comment_id)
        reply_id = try values.decodeIfPresent(String.self, forKey: .reply_id)
        user = try values.decodeIfPresent(CommunityUser.self, forKey: .user)
        replies = try values.decodeIfPresent([Replies].self, forKey: .replies)
    }

}

struct Replies : Codable {
    let id          : Int?
    let body        : String?
    let post_id     : Int?
    let user_id     : Int?
    let created_at  : String?
    let updated_at  : String?
    let comment_id  : Int?
    let reply_id    : Int?
    let user        : CommunityUser?

    enum CodingKeys: String, CodingKey {
        case id         = "id"
        case body       = "body"
        case post_id    = "post_id"
        case user_id    = "user_id"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case comment_id = "comment_id"
        case reply_id   = "reply_id"
        case user       = "user"
    }

    init(from decoder: Decoder) throws {
        let values      = try decoder.container(keyedBy: CodingKeys.self)
        id              = try values.decodeIfPresent(Int.self, forKey: .id)
        body            = try values.decodeIfPresent(String.self, forKey: .body)
        post_id         = try values.decodeIfPresent(Int.self, forKey: .post_id)
        user_id         = try values.decodeIfPresent(Int.self, forKey: .user_id)
        created_at      = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at      = try values.decodeIfPresent(String.self, forKey: .updated_at)
        comment_id      = try values.decodeIfPresent(Int.self, forKey: .comment_id)
        reply_id        = try values.decodeIfPresent(Int.self, forKey: .reply_id)
        user            = try values.decodeIfPresent(CommunityUser.self, forKey: .user)
    }

}

struct CommentReply     :  Codable {
    let success         : Bool?
    let message         : String?
    let next_offset     : Int?
    let comment         : Replies?

    enum CodingKeys: String, CodingKey {

        case success        = "success"
        case message        = "message"
        case next_offset    = "next_offset"
        case comment        = "comment"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        next_offset = try values.decodeIfPresent(Int.self, forKey: .next_offset)
        comment = try values.decodeIfPresent(Replies.self, forKey: .comment)
    }

}


