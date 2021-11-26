//
//  CommunityPosts.swift
//  kjkii
//
//  Created by Shahbaz on 15/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation

struct ComPosts {
    var offset = String()
    var user_id = String()
    var url : URL?
    func getPosts(completion: @escaping(Result<CommunityResponse, ErrorMessage>)->Void){
        print(url?.absoluteString)
        
        HttpUtility.shared.getApiData(requestUrl: url!, resultType: CommunityResponse.self) { (result, done) in
            if done{
                guard let result = result else {
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









struct CommunityResponse    : Codable {
    public var success      : Bool!
    public var message      : String!
    public var next_offset  : Int!
    public var posts        : [Posts]!
}

struct SinglePOst: Codable{
    var success : Bool
    var message: String
   var post: Posts
}

public struct Posts : Codable {
    
    public var id : Int!
    public var body : String!
    public var user_id : Int!
    public var created_at : String!
    public var updated_at : String!
    public var path : String!
    public var link : String!
    public var likes_count : Int!
    public var comments_count : Int!
    public var IsLiked : Int!
    var media : [Media]!
    var user : MyUser!
    
}




struct MyUser: Codable {
    var id : Int!
    var name : String!
    var profile_pic : String?
}



struct Media : Codable {
    public var id : Int!
    public var path : String!
    public var post_id : Int!
    public var user_id : Int!
    
}


struct CommunityUser : Codable {
    let id : Int?
    let name : String?
    let profile_pic : String?
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case profile_pic = "profile_pic"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        profile_pic = try values.decodeIfPresent(String.self, forKey: .profile_pic)
    }
    
}

struct SentRequestData: Codable{
    var next_offset: Int?
    var Sentrequests: SentrequestsData?
   
}
struct SentrequestsData: Codable{
    var id: Int?
    var name: String?
   var profile_pic: String?
    
   
}




