//
//  GetYourMatch.swift
//  kjkii
//
//  Created by Shahbaz on 27/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation
struct GetYourMatch {
    init() {}
    static let shared = GetYourMatch()
    func getMatches(completion : @escaping (Result<GetYourMatchResponse, ErrorMessage>) -> Void){
        let url = URL(string: EndPoints.BASE_URL + "match")!
        HttpUtility.shared.getApiData(requestUrl: url, resultType: GetYourMatchResponse.self) { (result, done) in
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


struct GetYourMatchResponse : Codable {
    let success : Bool?
    let message : String?
    let likes : [Likes]?
    let matches : [Matches]?
    
    enum CodingKeys: String, CodingKey {
        
        case success = "success"
        case message = "message"
        case likes = "likes"
        case matches = "matches"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        likes = try values.decodeIfPresent([Likes].self, forKey: .likes)
        matches = try values.decodeIfPresent([Matches].self, forKey: .matches)
    }
    
}


struct Likes : Codable {
    let id : Int?
    let profile_pic : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case profile_pic = "profile_pic"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        profile_pic = try values.decodeIfPresent(String.self, forKey: .profile_pic)
    }
    
}


struct Matches : Codable {
    let id : Int?
    let name : String?
    let profile_pic : String?
    let last_online : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case profile_pic = "profile_pic"
        case last_online = "last_online"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        profile_pic = try values.decodeIfPresent(String.self, forKey: .profile_pic)
        last_online = try values.decodeIfPresent(String.self, forKey: .last_online)
    }
    
}



