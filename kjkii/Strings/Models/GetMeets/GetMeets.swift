//
//  File.swift
//  kjkii
//
//  Created by Shahbaz on 14/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation

struct GetMeets {
    init() { }
    static let shared = GetMeets()
    func get(completion: @escaping(Result<GetMeetResponse, ErrorMessage>)-> Void){
        let url = URL(string: EndPoints.BASE_URL + "meet")!
        HttpUtility.shared.getApiData(requestUrl: url, resultType: GetMeetResponse.self) { (result, done) in
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





struct GetMeetResponse : Codable {
    let success : Bool?
    let message : String?
    let users : [MeetUsers]?
    enum CodingKeys: String, CodingKey {
        
        case success = "success"
        case message = "message"
        case users = "users"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        users = try values.decodeIfPresent([MeetUsers].self, forKey: .users)
    }
    
}



struct GetProfileResponse : Codable {
    let success         : Bool?
    let message         : String?
    let user            : MeetUsers?
    
    enum CodingKeys: String, CodingKey {
        
        case success    = "success"
        case message    = "message"
        case user       = "user"
    }
    
    init(from decoder: Decoder) throws {
        let values  = try decoder.container(keyedBy: CodingKeys.self)
        success     = try values.decodeIfPresent(Bool.self, forKey: .success)
        message     = try values.decodeIfPresent(String.self, forKey: .message)
        user        = try values.decodeIfPresent(MeetUsers.self, forKey: .user)
    }
    
}


struct MeetUsers : Codable {
    let id                  : Int?
    let name                : String?
    let email               : String?
    let email_verified_at   : String?
    let phone               : String?
    let role                : String?
    let profile_pic         : String?
    let birthday            : String?
    let gender_identity     : String?
    let sexual_identity     : String?
    let pronouns            : String?
    let bio                 : String?
    let relationship_status : String?
    let height              : String?
    let looking_for         : String?
    let drink               : String?
    let smoke               : String?
    let cannabis            : String?
    let political_views     : String?
    let religion            : String?
    let diet_like           : String?
    let sign                : String?
    let pets                : String?
    let kids                : String?
    let facebook            : String?
    let instagram           : String?
    let tiktok              : String?
    let last_online         : String?
    let latitude            : String?
    let longitude           : String?
    let auth_token          : String?
    let created_at          : String?
    let updated_at          : String?
    let age                 : Int?
    let friends_count       : Int?
    let distance            : String?
    let profile_pics        : [Profile_pics]?
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case email = "email"
        case email_verified_at = "email_verified_at"
        case phone = "phone"
        case role = "role"
        case profile_pic = "profile_pic"
        case birthday = "birthday"
        case gender_identity = "gender_identity"
        case sexual_identity = "sexual_identity"
        case pronouns = "pronouns"
        case bio = "bio"
        case relationship_status = "relationship_status"
        case height = "height"
        case looking_for = "looking_for"
        case drink = "drink"
        case smoke = "smoke"
        case cannabis = "cannabis"
        case political_views = "political_views"
        case religion = "religion"
        case diet_like = "diet_like"
        case sign = "sign"
        case pets = "pets"
        case kids = "kids"
        case facebook = "facebook"
        case instagram = "instagram"
        case tiktok = "tiktok"
        case last_online = "last_online"
        case latitude = "latitude"
        case longitude = "longitude"
        case auth_token = "auth_token"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case age = "age"
        case friends_count = "friends_count"
        case distance = "distance"
        case profile_pics = "profile_pics"
    }
    
    init(from decoder: Decoder) throws {
        let values          = try decoder.container(keyedBy: CodingKeys.self)
        id                  = try values.decodeIfPresent(Int.self, forKey: .id)
        name                = try values.decodeIfPresent(String.self, forKey: .name)
        email               = try values.decodeIfPresent(String.self, forKey: .email)
        email_verified_at   = try values.decodeIfPresent(String.self, forKey: .email_verified_at)
        phone               = try values.decodeIfPresent(String.self, forKey: .phone)
        role                = try values.decodeIfPresent(String.self, forKey: .role)
        profile_pic         = try values.decodeIfPresent(String.self, forKey: .profile_pic)
        birthday            = try values.decodeIfPresent(String.self, forKey: .birthday)
        gender_identity     = try values.decodeIfPresent(String.self, forKey: .gender_identity)
        sexual_identity     = try values.decodeIfPresent(String.self, forKey: .sexual_identity)
        pronouns            = try values.decodeIfPresent(String.self, forKey: .pronouns)
        bio                 = try values.decodeIfPresent(String.self, forKey: .bio)
        relationship_status = try values.decodeIfPresent(String.self, forKey: .relationship_status)
        height              = try values.decodeIfPresent(String.self, forKey: .height)
        looking_for         = try values.decodeIfPresent(String.self, forKey: .looking_for)
        drink               = try values.decodeIfPresent(String.self, forKey: .drink)
        smoke               = try values.decodeIfPresent(String.self, forKey: .smoke)
        cannabis            = try values.decodeIfPresent(String.self, forKey: .cannabis)
        political_views     = try values.decodeIfPresent(String.self, forKey: .political_views)
        religion            = try values.decodeIfPresent(String.self, forKey: .religion)
        diet_like           = try values.decodeIfPresent(String.self, forKey: .diet_like)
        sign                = try values.decodeIfPresent(String.self, forKey: .sign)
        pets                = try values.decodeIfPresent(String.self, forKey: .pets)
        kids                = try values.decodeIfPresent(String.self, forKey: .kids)
        facebook            = try values.decodeIfPresent(String.self, forKey: .facebook)
        instagram           = try values.decodeIfPresent(String.self, forKey: .instagram)
        tiktok              = try values.decodeIfPresent(String.self, forKey: .tiktok)
        last_online         = try values.decodeIfPresent(String.self, forKey: .last_online)
        latitude            = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude           = try values.decodeIfPresent(String.self, forKey: .longitude)
        auth_token          = try values.decodeIfPresent(String.self, forKey: .auth_token)
        created_at          = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at          = try values.decodeIfPresent(String.self, forKey: .updated_at)
        age                 = try values.decodeIfPresent(Int.self, forKey: .age)
        friends_count       = try values.decodeIfPresent(Int.self, forKey: .friends_count)
        distance            = try values.decodeIfPresent(String.self, forKey: .distance)
        profile_pics        = try values.decodeIfPresent([Profile_pics].self, forKey: .profile_pics)
    }
}

struct Profile_pics : Codable {
    let id : Int?
    let path : String?
    let user_id : Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case path = "path"
        case user_id = "user_id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        user_id = try values.decodeIfPresent(Int.self, forKey: .user_id)
    }
    
}

