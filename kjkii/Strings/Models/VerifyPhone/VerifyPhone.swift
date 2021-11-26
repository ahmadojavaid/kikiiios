//
//  VerifyPhone.swift
//  kjkii
//
//  Created by Shahbaz on 08/10/2020.
//  Copyright © 2020 abbas. All rights reserved.
//

import Foundation


struct SendOTP: Codable {
    var phone = String()
    func send(completion : @escaping(Result<PhoneNumberResponse, ErrorMessage>)->Void){
        let url = URL(string: EndPoints.BASE_URL + "continue/with-phone")!
        do{
            let data = try JSONEncoder().encode(self)
            HttpUtility.shared.postApiData(requestUrl: url, requestBody: data, resultType: PhoneNumberResponse.self) { (result) in
                guard let result = result else {
                    completion(.failure(.invalidResponse))
                    return
                }
                dump(result)
                completion(.success(result))
            }
        }catch
        {
            print("Error")
        }
        
        
    }
}



struct PhoneNumberResponse : Codable {
    let success         : Bool?
    let message         : String?
    let user            : PhoneUser?
    
    enum CodingKeys: String, CodingKey {
        case success    = "success"
        case message    = "message"
        case user       = "user"
    }
    
    init(from decoder: Decoder) throws {
        let values  = try decoder.container(keyedBy: CodingKeys.self)
        success     = try values.decodeIfPresent(Bool.self, forKey: .success)
        message     = try values.decodeIfPresent(String.self, forKey: .message)
        user        = try values.decodeIfPresent(PhoneUser.self, forKey: .user)
    }
    
}



struct PhoneUser : Codable {
    let id : Int?
    let name : String?
    let email : String?
    let email_verified_at : String?
    let phone : String?
    let role : String?
    let profile_pic : String?
    let birthday : String?
    let profile_verified : String?
    let gender_identity : String?
    let sexual_identity : String?
    let pronouns : String?
    let bio : String?
    let relationship_status : String?
    let height : String?
    let looking_for : String?
    let drink : String?
    let smoke : String?
    let cannabis : String?
    let political_views : String?
    let religion : String?
    let diet_like : String?
    let sign : String?
    let pets : String?
    let kids : String?
    let facebook : String?
    let instagram : String?
    let tiktok : String?
    let last_online : String?
    let latitude : String?
    let longitude : String?
    let auth_token : String?
    let created_at : String?
    let updated_at : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case email = "email"
        case email_verified_at = "email_verified_at"
        case phone = "phone"
        case role = "role"
        case profile_pic = "profile_pic"
        case birthday = "birthday"
        case profile_verified = "profile_verified"
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
    }
    
    init(from decoder: Decoder) throws {
        let values  = try decoder.container(keyedBy: CodingKeys.self)
        id          = try values.decodeIfPresent(Int.self, forKey: .id)
        name        = try values.decodeIfPresent(String.self, forKey: .name)
        email       = try values.decodeIfPresent(String.self, forKey: .email)
        email_verified_at = try values.decodeIfPresent(String.self, forKey: .email_verified_at)
        phone       = try values.decodeIfPresent(String.self, forKey: .phone)
        role        = try values.decodeIfPresent(String.self, forKey: .role)
        profile_pic = try values.decodeIfPresent(String.self, forKey: .profile_pic)
        birthday    = try values.decodeIfPresent(String.self, forKey: .birthday)
        profile_verified = try values.decodeIfPresent(String.self, forKey: .profile_verified)
        gender_identity = try values.decodeIfPresent(String.self, forKey: .gender_identity)
        sexual_identity = try values.decodeIfPresent(String.self, forKey: .sexual_identity)
        pronouns    = try values.decodeIfPresent(String.self, forKey: .pronouns)
        bio         = try values.decodeIfPresent(String.self, forKey: .bio)
        relationship_status = try values.decodeIfPresent(String.self, forKey: .relationship_status)
        height      = try values.decodeIfPresent(String.self, forKey: .height)
        looking_for = try values.decodeIfPresent(String.self, forKey: .looking_for)
        drink       = try values.decodeIfPresent(String.self, forKey: .drink)
        smoke       = try values.decodeIfPresent(String.self, forKey: .smoke)
        cannabis    = try values.decodeIfPresent(String.self, forKey: .cannabis)
        political_views = try values.decodeIfPresent(String.self, forKey: .political_views)
        religion    = try values.decodeIfPresent(String.self, forKey: .religion)
        diet_like   = try values.decodeIfPresent(String.self, forKey: .diet_like)
        sign        = try values.decodeIfPresent(String.self, forKey: .sign)
        pets        = try values.decodeIfPresent(String.self, forKey: .pets)
        kids        = try values.decodeIfPresent(String.self, forKey: .kids)
        facebook    = try values.decodeIfPresent(String.self, forKey: .facebook)
        instagram   = try values.decodeIfPresent(String.self, forKey: .instagram)
        tiktok      = try values.decodeIfPresent(String.self, forKey: .tiktok)
        last_online = try values.decodeIfPresent(String.self, forKey: .last_online)
        latitude    = try values.decodeIfPresent(String.self, forKey: .latitude)
        longitude   = try values.decodeIfPresent(String.self, forKey: .longitude)
        auth_token  = try values.decodeIfPresent(String.self, forKey: .auth_token)
        created_at  = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at  = try values.decodeIfPresent(String.self, forKey: .updated_at)
    }
    
}




struct VerifyCode : Codable {
    var code = String()
    func verifyCode(completion : @escaping (Result<VerifyCodeResponse, ErrorMessage>)->Void){
        let url = URL(string: EndPoints.BASE_URL + "verify/phone")!
        do {
            let data = try JSONEncoder().encode(self)
            HttpUtility.shared.postApiDataWithAuth(requestUrl: url, requestBody: data, resultType: VerifyCodeResponse.self) { (result) in
                guard let result = result else {
                    completion(.failure(.invalidResponse))
                    return
                }
                completion(.success(result))
            }
        }
        catch{
            print("Error in entral")
        }
    }
}




struct VerifyCodeResponse : Codable {
    let success : Bool?
    let message : String?
    let data    : UserData?
    
    enum CodingKeys: String, CodingKey {
        
        case success = "success"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(UserData.self, forKey: .data)
    }
}

struct UserData : Codable {
    let user : PhoneUser?
    
    enum CodingKeys: String, CodingKey {
        
        case user = "user"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = try values.decodeIfPresent(PhoneUser.self, forKey: .user)
    }
}


